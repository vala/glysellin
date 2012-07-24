class AddPublishedToGlysellinBundlesAndProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :published, :boolean, default: true
    add_column :glysellin_bundles, :published, :boolean, default: true
  end
end
