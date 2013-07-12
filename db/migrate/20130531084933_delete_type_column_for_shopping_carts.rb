class DeleteTypeColumnForShoppingCarts < ActiveRecord::Migration
  def up
    remove_column(:shopping_carts,:type)
  end

  def down
  end
end
