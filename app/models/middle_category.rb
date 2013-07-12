class MiddleCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_paranoid
  attr_accessible :middle_category_name,:big_category_id
  belongs_to :big_category
  has_many :small_categories, :conditions => ["small_categories.deleted_at is null"], :dependent => :destroy


  validates :big_category_id, :presence => true
  validates  :middle_category_name,  :presence => true

end
