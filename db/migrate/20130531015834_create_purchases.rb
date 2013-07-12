class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :address_id
      t.decimal :total_price
      t.decimal :protif
      t.integer :status
      t.timestamps
    end
  end
end
