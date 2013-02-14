class AddWeightToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :weight, :decimal
  end
end
