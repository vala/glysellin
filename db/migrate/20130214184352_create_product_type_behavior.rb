class CreateProductTypeBehavior < ActiveRecord::Migration
  def up
    create_table :glysellin_product_types_properties, id: false do |t|
      t.references :product_type, :product_property
    end

    add_column :glysellin_products, :product_type_id, :integer
  end

  def down
    remove_column :glysellin_products, :product_type_id

    drop_table :glysellin_product_types_properties
  end
end
