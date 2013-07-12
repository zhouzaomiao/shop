class CreateProductPictrues < ActiveRecord::Migration
  def change
    create_table :product_pictrues do |t|

      t.timestamps
    end
  end
end
