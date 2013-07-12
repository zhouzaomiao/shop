class ShoppingCart < ActiveRecord::Base
  attr_accessible :quantity
  belongs_to :product
  belongs_to :user
  belongs_to :pruchase

end
