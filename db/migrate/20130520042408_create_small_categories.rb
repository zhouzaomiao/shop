class CreateSmallCategories < ActiveRecord::Migration
  def change
    create_table :small_categories do |t|
      t.integer :middle_category_id
      t.string :small_category_name
      t.timestamps
    end
  end
end
