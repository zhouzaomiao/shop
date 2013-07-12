class ChangeColumnTelForAddresses < ActiveRecord::Migration
  def up
    change_column :addresses, :tel, :string
  end

  def down
  end
end
