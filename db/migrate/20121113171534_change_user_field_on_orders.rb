class ChangeUserFieldOnOrders < ActiveRecord::Migration
  def change
    rename_column :glysellin_orders, :user_id, :customer_id
  end
end
