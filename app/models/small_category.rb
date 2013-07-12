class SmallCategory < ActiveRecord::Base
  attr_accessor :big_category_id
  
  acts_as_paranoid
  belongs_to :middle_category
  has_many :products, :conditions => ["products.deleted_at is null"], :dependent => :destroy
  
  validates :middle_category_id, :presence => true
  validates  :small_category_name,  :presence => true
end
