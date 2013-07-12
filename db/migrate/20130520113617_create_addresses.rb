class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :address
      t.integer :tel
      t.string :name
      t.timestamps
    end
  end
end

