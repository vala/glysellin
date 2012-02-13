class AlterOrderItemPrices < ActiveRecord::Migration
  def up
    change_column :glysellin_order_items, :df_price, :float
    change_column :glysellin_order_items, :vat_rate, :float
  end

  def down
    change_column :glysellin_order_items, :df_price, :integer
    change_column :glysellin_order_items, :vat_rate, :integer
  end
end
