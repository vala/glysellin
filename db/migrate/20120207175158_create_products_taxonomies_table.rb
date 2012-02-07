class CreateProductsTaxonomiesTable < ActiveRecord::Migration
  def up
    create_table :products_taxonomies, :id => false do |t|
      t.integer :product_id
      t.integer :taxonomy_id
    end
  end

  def down
    drop_table :products_taxonomies
  end
end
