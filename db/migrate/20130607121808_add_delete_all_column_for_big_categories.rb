class AddDeleteAllColumnForBigCategories < ActiveRecord::Migration
  def up
    add_column :big_categories, :deleted_at, :datetime
    add_column :middle_categories, :deleted_at, :datetime
    add_column :small_categories, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
    add_column :admins, :deleted_at, :datetime
    add_column :addresses, :deleted_at, :datetime
    add_column :attachments, :deleted_at, :datetime
    add_column :ckeditor_assets, :deleted_at, :datetime
    add_column :products, :deleted_at, :datetime
    add_column :product_pictrues, :deleted_at, :datetime
    add_column :purchases, :deleted_at, :datetime
    add_column :shopping_carts, :deleted_at, :datetime

  end

  def down
    remove_column :big_categories, :deleted_at
    remove_column :big_categories, :deleted_at
    remove_column :middle_categories, :deleted_at
    remove_column :small_categories, :deleted_at
    remove_column :users, :deleted_at
    remove_column :admins, :deleted_at
    remove_column :addresses, :deleted_at
    remove_column :attachments, :deleted_at
    remove_column :ckeditor_assets, :deleted_at
    remove_column :products, :deleted_at
    remove_column :product_pictrues, :deleted_at
    remove_column :purchases, :deleted_at
    remove_column :shopping_carts, :deleted_at
  end
end
