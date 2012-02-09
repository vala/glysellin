class AddAdditionalFieldsToGlysellinAddresses < ActiveRecord::Migration
  def change
    add_column :glysellin_addresses, :additional_fields, :text

  end
end
