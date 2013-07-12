class AddHeadShowColumnForBigCategories < ActiveRecord::Migration
  def up
    add_column :big_categories, :head_show, :boolean
  end

  def down
  end
end
