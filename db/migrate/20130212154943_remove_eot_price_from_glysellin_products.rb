class RemoveEotPriceFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :eot_price
  end

  def down
    add_column :glysellin_products, :eot_price, :decimal
  end
end
