class ChangeAddressableAssociationsInGlysellinAddresses < ActiveRecord::Migration
  def up
    remove_column :glysellin_addresses, :addressable_type
    remove_column :glysellin_addresses, :addressable_id
    add_column :glysellin_addresses, :shipped_addressable_type, :string
    add_column :glysellin_addresses, :shipped_addressable_id, :integer
    add_column :glysellin_addresses, :billed_addressable_type, :string
    add_column :glysellin_addresses, :billed_addressable_id, :integer
  end

  def down
    add_column :glysellin_addresses, :addressable_type, :string
    add_column :glysellin_addresses, :addressable_id, :integer
  end
end
