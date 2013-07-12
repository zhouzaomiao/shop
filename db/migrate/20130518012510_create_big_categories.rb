class CreateBigCategories < ActiveRecord::Migration
  def change
    create_table :big_categories do |t|
      t.string   :name, :default => ''
      t.timestamps
    end
  end
end
