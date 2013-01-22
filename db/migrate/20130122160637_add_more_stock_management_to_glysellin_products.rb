class AddMoreStockManagementToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :unlimited_stock, :boolean
    add_column :glysellin_products, :published, :boolean
  end
end
