class AddShippingMethodIdToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :shipping_method_id, :integer
  end
end
