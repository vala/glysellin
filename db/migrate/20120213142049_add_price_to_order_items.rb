class AddPriceToOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :price, :float
  end
end
