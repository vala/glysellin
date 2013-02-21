class AddUnmarkedPriceToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :unmarked_price, :decimal, precision: 11, scale: 2
  end
end
