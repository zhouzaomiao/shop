class BigCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  
  attr_accessible :name
  has_many :middle_categories, :conditions => ["middle_categories.deleted_at is null"], :dependent => :destroy
  acts_as_paranoid
  
  validates :name, :presence => true

  end
