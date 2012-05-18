class AddPriceToOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :price, :decimal, precision: 11, scale: 2
  end
end
