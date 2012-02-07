class CreateProductsTaxonomiesTable < ActiveRecord::Migration
  def up
    create_table :glysellin_products_taxonomies, :id => false do |t|
      t.integer :product_id
      t.integer :taxonomy_id
    end
  end

  def down
    drop_table :glysellin_products_taxonomies
  end
end
