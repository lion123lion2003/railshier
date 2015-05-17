class ProductFamily < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :products, :foreign_key => 'family_id'

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false},
    :format => { :with => /\A\w+\z/, :message => "Only letters and numbers are allowed" },
    :length => { :maximum => 16 }

  before_save :format_name


  def self.policy_class
    GroupPolicy
  end

  def format_name
    name.upcase!
  end

  def to_s
    name
  end

end
