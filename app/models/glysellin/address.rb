module Glysellin
  class Address < ActiveRecord::Base
    self.table_name = 'glysellin_addresses'

    # Additional fields can be added through Glysellin.config.additional_address_fields in an app initializer
    store :additional_fields, :accessors => Glysellin.additional_address_fields
    attr_accessible *Glysellin.additional_address_fields
    # Relations
    #
    # And address can be used as shipping or billing address
    belongs_to :shipped_addressable, polymorphic: true
    belongs_to :billed_addressable, polymorphic: true

    attr_accessible :activated, :first_name, :last_name, :address, :zip, :city,
      :country, :tel, :fax, :company, :company_name, :vat_number,
      :address_details, :additional_fields, :shipped_addressable_type,
      :shipped_addressable_id, :billed_addressable_type, :billed_addressable_id

    # Validations
    #
    # Validates presence of the fields defined in the config file or the glysellin initializer
    validates_presence_of *Glysellin.address_presence_validation_keys

    def same_as?(other)
      clone_attributes == other.clone_attributes
    end

    def clone_attributes
      clone.attributes.select do |key, value|
        self.class.accessible_attributes.include?(key) &&
          !key.to_s.match(/_addressable_(type|id)$/)
      end
    end
  end
end
