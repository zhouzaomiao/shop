class AddDeleteAtColumnForComments < ActiveRecord::Migration
  def up
    add_column :comments, :deleted_at, :datetime
  end

  def down
    remove_column :comments, :deleted_at
  end
end
