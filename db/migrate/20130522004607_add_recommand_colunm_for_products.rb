class AddRecommandColunmForProducts < ActiveRecord::Migration
  def up
    add_column :products, :recommand, :boolean
  end

  def down
    remove_column :products, :recommand
  end
end
