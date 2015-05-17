class Product < ActiveRecord::Base
  attr_accessible :end_support_date, :name, :number, :status, :family_id

  belongs_to :family, :class_name => 'ProductFamily', :foreign_key => 'family_id'
  has_many :product_licenses
  has_many :licenses, :through => :product_licenses

  STATUS_ACTIVE = 1
  STATUS_CLOSED = 4

  validates :number, :presence => true, :uniqueness => {:case_sensitive => false},
    :format => { :with => /\A[a-zA-Z\d]+\z/, :message => "Only letters and numbers are allowed" },
    :length => { :maximum => 16 }
  validates :status, :presence => true
  validate :end_support_date, :datetime => true

  before_save :format_number


  def self.policy_class
    GroupPolicy
  end

  def format_number
    number.upcase!
  end

  def to_s
    number
  end

end
