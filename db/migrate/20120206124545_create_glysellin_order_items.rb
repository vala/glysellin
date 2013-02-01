class CreateGlysellinOrderItems < ActiveRecord::Migration
  def change
    create_table :glysellin_order_items do |t|
      t.string :sku
      t.string :name
      t.decimal :eot_price, precision: 11, scale: 2
      t.decimal :price, precision: 11, scale: 2
      t.decimal :vat_rate, precision: 11, scale: 2
      t.integer :quantity
      t.integer :order_id

      t.timestamps
    end
  end
end
