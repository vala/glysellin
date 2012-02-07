class CreateGlysellinOrderItems < ActiveRecord::Migration
  def change
    create_table :glysellin_order_items do |t|
      t.string :sku
      t.string :name
      t.integer :df_price
      t.integer :vat_rate

      t.timestamps
    end
  end
end
