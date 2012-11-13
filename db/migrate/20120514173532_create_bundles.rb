class CreateBundles < ActiveRecord::Migration
  def change
    create_table :glysellin_bundles do |t|
      t.string :sku
      t.string :name
      t.string :slug
      t.text :description
      t.decimal :eot_price, :default => 0, :precision => 11, :scale => 2
      t.decimal :vat_rate, :default => 0, :precision => 11, :scale => 2
      t.integer :in_stock
      t.timestamps
    end
  end
end
