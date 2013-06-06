module Glysellin
  module Orderer
    extend ActiveSupport::Concern

    included do
      has_one :billing_address, class_name: 'Glysellin::Address',
        as: :billed_addressable, dependent: :destroy, autosave: true

      has_one :shipping_address, class_name: 'Glysellin::Address',
        as: :shipped_addressable, dependent: :destroy, autosave: true

      attr_writer :use_another_address_for_shipping

      attr_accessible :billing_address_attributes, :shipping_address_attributes,
        :use_another_address_for_shipping

      accepts_nested_attributes_for :billing_address, :shipping_address
    end

    def use_another_address_for_shipping
      !(shipping_address.new_record? && !super)
    end

    def has_shipping_address?
      shipping_address && shipping_address.id.present?
    end
  end
end