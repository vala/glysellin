class AddOrderIdToGlysellinOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :order_id, :integer

  end
end
