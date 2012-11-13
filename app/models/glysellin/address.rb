module Glysellin
  class Address < ActiveRecord::Base
    self.table_name = 'glysellin_addresses'

    # Relations
    #
    # And address can be used as shipping or billing address
    has_many :billed_orders, :class_name => 'Glysellin::Order', :foreign_key => 'billing_address_id', :inverse_of => :billing_address
    has_many :shipped_orders, :class_name => 'Glysellin::Order', :foreign_key => 'shipping_address_id', :inverse_of => :shipping_address

    attr_accessible :activated, :first_name, :last_name, :address, :zip, :city,
        :country, :tel, :fax, :billed_orders, :shipped_orders, :company,
        :company_name, :vat_number, :address_details, :shipped_orders


    # Validations
    #
    # Validates presence of the fields defined in the config file or the glysellin initializer
    validates_presence_of Glysellin.address_presence_validation_keys
    # Additional fields can be added through Glysellin.config.additional_address_fields in an app initializer
    store :additional_fields, :accessors => Glysellin.additional_address_fields
  end
end
