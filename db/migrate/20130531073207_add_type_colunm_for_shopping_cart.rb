class AddTypeColunmForShoppingCart < ActiveRecord::Migration
  def up
    add_column :shopping_carts, :type, :integer
  end

  def down
    remove_column :shopping_carts, :type
  end
end
