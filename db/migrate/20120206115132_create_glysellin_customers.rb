class CreateGlysellinCustomers < ActiveRecord::Migration
  def change
    create_table :glysellin_customers do |t|
      t.integer :user_id
      t.timestamps
    end
  end
end
