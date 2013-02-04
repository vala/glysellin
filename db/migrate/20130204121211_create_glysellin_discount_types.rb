class CreateGlysellinDiscountTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_discount_types do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
