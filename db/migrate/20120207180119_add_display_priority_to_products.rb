class AddDisplayPriorityToProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :display_priority, :integer, :default => 1
  end
end
