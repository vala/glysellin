class AddTransactionIdToPayments < ActiveRecord::Migration
  def change
    add_column :glysellin_payments, :transaction_id, :integer
  end
end
