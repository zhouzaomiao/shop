class AddDayWeekQuarterYearAddColumnForPurchases < ActiveRecord::Migration
  def up
    add_column :purchases, :week, :integer
    add_column :purchases, :month, :integer
    add_column :purchases, :quarter, :integer
    add_column :purchases, :year, :integer
  end

  def down
    remove_column :purchases, :week #周
    remove_column :purchases, :month  #月
    remove_column :purchases, :quarter #季度
    remove_column :purchases, :year #年
  end
end
