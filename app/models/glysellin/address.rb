module Glysellin
  class Address < ActiveRecord::Base
    self.table_name = 'glysellin_addresses'
    has_many :orders
    # Additional fields can be added through Glysellin.config.additional_address_fields in the custom initializer
    store :additional_fields, :accessors => Glysellin.additional_address_fields
  end
end
