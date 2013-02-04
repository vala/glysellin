class CreateGlysellinOrderAdjustments < ActiveRecord::Migration
  def change
    create_table :glysellin_order_adjustments do |t|
      t.string :name
      t.decimal :value, precision: 11, scale: 2
      t.integer :order_id
      t.integer :adjustment_id
      t.string :adjustment_type

      t.timestamps
    end
  end
end
