class AddShoppingTypeColunmForShoppingCarts < ActiveRecord::Migration
  def up
    add_column :shopping_carts, :shopping_type, :integer
  end

  def down
     remove_column :shopping_carts, :shopping_type
  end
end
