class CreateGlysellinPaymentMethods < ActiveRecord::Migration
  def change
    create_table :glysellin_payment_methods do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
