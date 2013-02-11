class CreateGlysellinProductPropertyTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_product_property_types do |t|
      t.string :name
    end
  end
end
