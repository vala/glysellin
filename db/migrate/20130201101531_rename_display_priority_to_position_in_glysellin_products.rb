class RenameDisplayPriorityToPositionInGlysellinProducts < ActiveRecord::Migration
  def change
    rename_column :glysellin_products, :display_priority, :position
  end
end
