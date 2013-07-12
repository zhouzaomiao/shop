class DelectUserIdAndProductIdForAttachments < ActiveRecord::Migration
  def up
    remove_column(:attachments, :user_id, :product_id)
    add_column :attachments, :obj, :integer
  end

  def down
  end
end
