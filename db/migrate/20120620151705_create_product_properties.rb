class CreateProductProperties < ActiveRecord::Migration
  def change
    create_table :glysellin_product_properties do |t|
      t.string :name
      t.string :value
      t.decimal :adjustement, precision: 11, scale: 2
      t.integer :product_id
      
      t.timestamps
    end
  end
end
