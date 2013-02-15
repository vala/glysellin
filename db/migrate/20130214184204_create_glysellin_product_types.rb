class CreateGlysellinProductTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_product_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
