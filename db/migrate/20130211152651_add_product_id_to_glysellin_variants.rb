class AddProductIdToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :product_id, :integer
  end
end
