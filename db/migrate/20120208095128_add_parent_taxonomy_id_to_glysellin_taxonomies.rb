class AddParentTaxonomyIdToGlysellinTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :parent_taxonomy_id, :integer

  end
end
