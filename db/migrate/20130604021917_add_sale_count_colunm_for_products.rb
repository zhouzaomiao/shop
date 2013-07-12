class AddSaleCountColunmForProducts < ActiveRecord::Migration
  def up
    add_column :products, :sale_count, :integer
  end

  def down
    remove_column :products, :sale_count
  end
end
