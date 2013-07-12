class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :purchase_id
      t.decimal :purchase_price
      t.decimal :quantity
      t.timestamps
    end
  end
end
