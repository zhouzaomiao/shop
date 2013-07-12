class AddAvatarColunmForAttachment < ActiveRecord::Migration
  def up
    add_attachment :attachments, :avatar
  end

  def down
    remove_attachment :attachments, :avatar
  end
end
