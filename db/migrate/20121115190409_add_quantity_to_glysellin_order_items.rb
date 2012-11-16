class AddQuantityToGlysellinOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :quantity, :integer
  end
end
