class AddBundleToGlysellinOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :bundle, :boolean
  end
end
