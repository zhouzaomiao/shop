class CreateMiddleCategories < ActiveRecord::Migration
  def change
    create_table :middle_categories do |t|
      t.integer :big_category_id
      t.string :middle_category_name
      t.timestamps
    end
  end
end
