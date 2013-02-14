class CreateGlysellinVariants < ActiveRecord::Migration
  def change
    create_table :glysellin_variants do |t|
      t.string :sku
      t.string :name
      t.string :slug
      t.decimal :eot_price, precision: 11, scale: 2
      t.decimal :price, precision: 11, scale: 2
      t.integer :in_stock, default: 0
      t.boolean :unlimited_stock, default: false
      t.boolean :published, default: false
      t.integer :position

      t.timestamps
    end
  end
end
