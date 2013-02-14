class RemoveVariantColumnsFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :price, :decimal
    remove_column :glysellin_products, :in_stock, :integer
    remove_column :glysellin_products, :unlimited_stock, :boolean
    remove_column :glysellin_products, :weight, :boolean
  end

  def down
    add_column :glysellin_products, :price, :decimal
    add_column :glysellin_products, :in_stock, :integer
    add_column :glysellin_products, :unlimited_stock, :boolean
    add_column :glysellin_products, :weight, :boolean
  end
end
