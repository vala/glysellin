class CreateGlysellinOrderItems < ActiveRecord::Migration
  def change
    create_table :glysellin_order_items do |t|
      t.string :sku
      t.string :name
      t.decimal :df_price, precision: 11, scale: 2
      t.decimal :vat_rate, precision: 11, scale: 2

      t.timestamps
    end
  end
end
