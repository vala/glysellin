class AddSlugToTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :slug, :string
  end
end
