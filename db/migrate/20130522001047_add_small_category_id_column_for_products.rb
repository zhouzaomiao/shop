class AddSmallCategoryIdColumnForProducts < ActiveRecord::Migration
  def up
    add_column :products, :small_category_id, :integer
  end

  def down
    remove_colum :products, :small_category_id
  end
end
