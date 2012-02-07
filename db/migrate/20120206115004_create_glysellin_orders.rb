class CreateGlysellinOrders < ActiveRecord::Migration
  def change
    create_table :glysellin_orders do |t|
      t.string :ref
      t.string :status
      t.datetime :paid_on
      t.integer :customer_id
      t.integer :billing_address_id
      t.integer :shipping_address_id
      
      t.timestamps
    end
  end
end
