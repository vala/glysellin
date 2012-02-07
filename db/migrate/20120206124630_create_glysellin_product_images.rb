class CreateGlysellinProductImages < ActiveRecord::Migration
  def change
    create_table :glysellin_product_images do |t|
      t.string :name

      t.timestamps
    end
  end
end
