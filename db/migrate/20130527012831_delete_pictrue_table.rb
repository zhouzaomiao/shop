class DeletePictrueTable < ActiveRecord::Migration
  def up
    drop_table :pictures
  end

  def down
  end
end
