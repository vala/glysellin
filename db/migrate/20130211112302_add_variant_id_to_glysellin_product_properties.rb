class AddVariantIdToGlysellinProductProperties < ActiveRecord::Migration
  def up
    add_column :glysellin_product_properties, :variant_id, :integer
    add_column :glysellin_product_properties, :variant_type, :string
    remove_column :glysellin_product_properties, :product_id
  end

  def down
    add_column :glysellin_product_properties, :product_id, :integer
    remove_column :glysellin_product_properties, :variant_type
    remove_column :glysellin_product_properties, :variant_id
  end
end
