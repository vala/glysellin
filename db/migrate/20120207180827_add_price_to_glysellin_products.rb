class AddPriceToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :price, :decimal, precision: 11, scale: 2
  end
end
