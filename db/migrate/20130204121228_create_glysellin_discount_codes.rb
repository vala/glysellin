class CreateGlysellinDiscountCodes < ActiveRecord::Migration
  def change
    create_table :glysellin_discount_codes do |t|
      t.string :name
      t.string :code
      t.integer :discount_type_id
      t.decimal :value, :precision => 11, :scale => 2
      t.datetime :expires_on

      t.timestamps
    end

    add_index :glysellin_discount_codes, :code
  end
end
