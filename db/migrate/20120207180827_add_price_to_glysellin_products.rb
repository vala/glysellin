class AddPriceToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :price, :double
    rename_column :glysellin_products, :integer_df_price, :df_price
    rename_column :glysellin_products, :integer_vat_rate, :vat_rate
  end
end
