class CreateGlysellinTaxonomies < ActiveRecord::Migration
  def change
    create_table :glysellin_taxonomies do |t|
      t.string :name

      t.timestamps
    end
  end
end
