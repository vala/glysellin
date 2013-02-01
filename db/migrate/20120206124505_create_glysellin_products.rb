class CreateGlysellinProducts < ActiveRecord::Migration
  def change
    create_table :glysellin_products do |t|
      t.string :sku
      t.string :name
      t.string :slug
      t.text :description
      t.decimal :eot_price, :precision => 11, :scale => 2
      t.decimal :price, precision: 11, scale: 2
      t.decimal :vat_rate, :precision => 11, :scale => 2
      t.integer :in_stock, :default => 0
      t.integer :position, :default => 1
      t.boolean :unlimited_stock
      t.boolean :published, default: true
      t.integer :brand_id


      t.timestamps
    end
  end
end
