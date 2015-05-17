class User < Principal
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable, :recoverable, :validatable
  devise :custom_authenticatable, :database_authenticatable, :registerable, :rememberable, :trackable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :primary_id, :source,
      :login, :lastname, :firstname, :status, :admin, :email_notification, :primary_group_id, :group_ids

  has_and_belongs_to_many :groups, :join_table => "#{table_name_prefix}groups_users#{table_name_suffix}"
  has_many :licenses

  validates_presence_of :login, :firstname, :lastname, :email
  validates_uniqueness_of :login, :if => Proc.new { |user| user.login_changed? && user.login.present? }, :case_sensitive => false
  # Login must contain letters, numbers, underscores only
  validates_format_of :login, :with => /\A[a-z0-9_\-@\.]*\z/i
  validates_length_of :login, :maximum => LOGIN_LENGTH_LIMIT
  validates_length_of :firstname, :lastname, :maximum => 30
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
  validates_length_of :email, :maximum => MAIL_LENGTH_LIMIT, :allow_nil => true

  scope :active, lambda { where("#{User.table_name}.status = #{STATUS_ACTIVE}") }

  def self.policy_class
    GroupPolicy
  end

  alias :base_reload :reload
  def reload(*arg)
    @teammates = nil
    @primary_group = nil
    base_reload(*arg)
  end


  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end

  def teammates
    unless @teammates.nil?
      return @teammates
    end
    @teammates = [self]
    groups.each do |g|
      @teammates += g.users.select {|u| u.active? and u.id != id}
    end
    @teammates.uniq!
    @teammates
  end

  # accept user or user id
  def teammate?(user)
    user_id = 0
    if user.class.to_s == 'User'
      user_id = user.id
    else
      user_id = user.to_i
    end
    teammates.map(&:id).include?(user_id)
  end

  def active?
    status == STATUS_ACTIVE
  end

  def primary_group
    @primary_group ||= groups.select{|g| g.id == primary_id}.first
  end

  def primary_group=(group)
    self.primary_group_id = group.id
    unless groups.include?(group)
      self.groups << group
    end
    @primary_group = group
  end

  def primary_group_id
    primary_id
  end

  def primary_group_id=(id)
    gids = group_ids
    unless gids.include?(id)
      gids << id
      self.group_ids = gids
    end
    self.primary_id = id
  end

  def to_s
      "#{firstname} #{lastname}"
  end

  # set ldap aqttributes for ldap users
  def set_ldap_attributes
      self.firstname = LDAP::Adapter.get_ldap_param(self.login, 'givenName').first
      #self.firstname = Devise::LDAP::Adapter.get_ldap_param(self.login, 'nickname')
      self.lastname = LDAP::Adapter.get_ldap_param(self.login, 'sn').first
      self.email = LDAP::Adapter.get_ldap_param(self.login, 'mail').first
      self.encrypted_password = ""
      self.source = User::SOURCE_LDAP
  end

  def save_ldap_attributes
      unless self.source == User::SOURCE_LDAP
          self.set_ldap_attributes
          self.save
      end
  end

  def self.search_ldap_users(q)
    ldp_con = LDAP::Connection.new()
    login_attr = ldp_con.attribute
    entries = ldp_con.search(q)
    users = []
    entries.each do |entry|
      users << {
        :login => entry[login_attr].empty? ? nil : entry.send(login_attr).first,
        :firstname => entry['givenName'].empty? ? nil : entry.send('givenName').first,
        :lastname => entry['sn'].empty? ? nil : entry.send('sn').first,
        :email => entry['mail'].empty? ? nil : entry.send('mail').first,
        :source => User::SOURCE_LDAP
      }
    end
    users
  end

  def source_ldap?
    source == User::SOURCE_LDAP
  end

  # overwrite function in custom_authenticatable plugin
  def valid_for_custom_authentication?(password)
      # Your authentication logic goes here and returns either true or false
      LDAP::Adapter.valid_credentials?(self.login, password)
  end

  # overwrite function in custom_authenticatable plugin
  def after_custom_authentication
      self.save_ldap_attributes
  end

  # Generates password encryption based on the given value.
  # database_authenticatable is required in devise define
  # This function is borrowed from the model of database_authenticatable
  # password_digest is a protected function in the model of database_authenticatable
  def password=(new_password)
    @password = new_password
    self.encrypted_password = password_digest(@password) if @password.present?
  end

end
