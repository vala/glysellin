class CreateBundleProducts < ActiveRecord::Migration
  def change
    create_table :glysellin_bundle_products do |t|
      t.integer :bundle_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps
    end
  end
end
