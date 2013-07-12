class AddScoreColumnForComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :score, :integer
  end

  def self.down
    remove_column :comments, :score
  end
end
