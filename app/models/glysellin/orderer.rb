module Glysellin
  module Orderer
    extend ActiveSupport::Concern
    included do
      has_one :billing_address, class_name: 'Glysellin::Address', as: :billed_addressable
      has_one :shipping_address, class_name: 'Glysellin::Address', as: :shipped_addressable
      
      attr_writer :use_another_address_for_shipping
      attr_accessible :billing_address_attributes, :shipping_address_attributes, :use_another_address_for_shipping

      accepts_nested_attributes_for :billing_address, :shipping_address

      def use_another_address_for_shipping
        !(shipping_address.new_object? && !@use_another_address_for_shipping)
      end
    end
  end
end