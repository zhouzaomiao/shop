class Comment < ActiveRecord::Base
  attr_accessible :product_id, :comment

  belongs_to :user
  belongs_to :product

  validates  :comment,  :presence => true
end
