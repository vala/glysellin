class AddBrandIdToProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :brand_id, :integer
  end
end
