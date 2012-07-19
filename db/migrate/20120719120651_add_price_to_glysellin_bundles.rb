class AddPriceToGlysellinBundles < ActiveRecord::Migration
  def change
    add_column :glysellin_bundles, :price, :decimal, precision: 11, scale: 2
  end
end
