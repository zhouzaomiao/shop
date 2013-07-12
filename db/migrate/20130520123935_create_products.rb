class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :samll_category_id
      t.integer :num
      t.string :name
      t.integer :count
      t.decimal :cost
      t.decimal :price
      t.datetime :up_time
      t.boolean :enabel, :default => false
      t.text :describe
      

      t.timestamps
    end
  end
end
