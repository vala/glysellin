class AddGlysellinBundlesTaxonomiesTable < ActiveRecord::Migration
  def up
    create_table :glysellin_bundles_taxonomies, id: false do |t|
      t.integer :bundle_id
      t.integer :taxonomy_id
    end
  end

  def down
    drop_table :glysellin_bundles_taxonomies
  end
end
