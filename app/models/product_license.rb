class ProductLicense < ActiveRecord::Base
  attr_accessible :license_id, :product_id, :expire_date, :quantity

  belongs_to :license
  belongs_to :product

  #validates_presence_of :license_id, :product_id, :expire_date, :quantity
  validates_presence_of :product_id, :quantity

  def self.policy_class
    ApplicationPolicy
  end

  def author_id
    license.author_id
  end
end
