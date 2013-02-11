class AddVariantIdToGlysellinProductProperties < ActiveRecord::Migration
  def change
    add_column :glysellin_product_properties, :variant_id, :integer
    add_column :glysellin_product_properties, :variant_type, :string
    remove_column :glysellin_product_properties, :product_id, :integer
  end
end
