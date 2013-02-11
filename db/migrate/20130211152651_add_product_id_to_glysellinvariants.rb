class AddProductIdToGlysellinvariants < ActiveRecord::Migration
  def change
    add_column :glysellinvariants, :product_id, :integer
  end
end
