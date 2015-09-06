class License < ActiveRecord::Base
  attr_accessible :name, :keyword, :hostid, :effective_date, :request_date,
    :customer_organization, :customer_manager, :project_name, :usage,
    :requestor_id, :product_ids

  belongs_to :author, :class_name => "User", :foreign_key => 'author_id'
  belongs_to :requestor, :class_name => "User", :foreign_key => 'requestor_id'
  has_many :product_licenses, :dependent => :delete_all, :autosave => true
  has_many :products, :through => :product_licenses, :autosave => true

  validates_presence_of :author, :hostid, :customer_organization, :effective_date

  #after_save :save_product_licenses

  def expire_date
    product_licenses.map(&:expire_date).max
  end

  def self.policy_class
    ApplicationPolicy
  end

  def get_product_license_by_product_id(id)
    product_licenses.select{|pl| pl.product_id == id}.first
  end

  def expired?
    expire_date < Date.today
  end

end
