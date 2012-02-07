class CreateGlysellinProducts < ActiveRecord::Migration
  def change
    create_table :glysellin_products do |t|
      t.string :sku
      t.string :name
      t.string :slug
      t.text :description
      t.integer :integer_df_price, :default => 0
      t.integer :integer_vat_rate, :default => 0

      t.timestamps
    end
  end
end
