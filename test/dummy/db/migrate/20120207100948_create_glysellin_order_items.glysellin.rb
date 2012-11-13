# This migration comes from glysellin (originally 20120206124545)
class CreateGlysellinOrderItems < ActiveRecord::Migration
  def change
    create_table :glysellin_order_items do |t|
      t.string :sku
      t.string :name
      t.boolean :bundle, default: false
      t.integer :eot_price
      t.integer :vat_rate

      t.timestamps
    end
  end
end
