class AddMoreStockManagementToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :unlimited_stock, :boolean
  end
end
