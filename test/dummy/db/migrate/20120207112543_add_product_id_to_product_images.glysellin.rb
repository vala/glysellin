# This migration comes from glysellin (originally 20120207112439)
class AddProductIdToProductImages < ActiveRecord::Migration
  def change
    add_column :glysellin_product_images, :product_id, :integer

  end
end
