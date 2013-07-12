class DeleteColunmSamllCategoryIdForProducts < ActiveRecord::Migration
  def up
    remove_column(:products,:samll_category_id)
  end

  def down
  end
end
