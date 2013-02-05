class AddWeightToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :weight, :decimal, precision: 11, scale: 3
  end
end
