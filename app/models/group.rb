class Group < Principal
  attr_accessible :name, :user_ids, :primary_id, :primary_user_id
  has_and_belongs_to_many :users,
                          :join_table   => "#{table_name_prefix}groups_users#{table_name_suffix}"

  validates_presence_of :lastname
  validates_uniqueness_of :lastname, :case_sensitive => false
  validates_length_of :lastname, :maximum => 255

  scope :sorted, lambda { order("#{table_name}.lastname ASC") }
  scope :named, lambda {|arg| where("LOWER(#{table_name}.lastname) = LOWER(?)", arg.to_s.strip)}

  def to_s
      lastname.to_s
  end

  def name
      lastname
  end

  def name=(arg)
      self.lastname = arg
  end

  def primary_user
    @primary_user ||= users.select{|u| u.id == primary_id}.first
  end

  def primary_user=(user)
    self.primary_user_id = user.id
    unless users.include?(user)
      self.users << user
    end
    @primary_user = user
  end

  def primary_user_id
    primary_id
  end

  def primary_user_id=(id)
    uids = user_ids
    unless uids.include?(id)
      uids << id
      self.user_ids = uids
    end
    self.primary_id = id
  end

end

