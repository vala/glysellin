module Glysellin
  module OrdersHelper

    # Generates Orderer form fields
    #
    # @param form Form object to which the fields are added
    # @param record Optional model object that implements Glysellin::Orderer
    #
    def addresses_fields_for form, record = nil
      # Copy addresses from record to form object
      if record
        %w(billing_address shipping_address).each do |addr|
          if (address = record.send("#{ addr }"))
            attrs = address.attributes.select do |key, value|
              Glysellin::Address.accessible_attributes.include?(key)
            end
          end

          unless (address = form.object.send(addr).presence) && address.id.present?
            form.object.send("#{ addr }=", Glysellin::Address.new(attrs))
          end
        end

        unless form.object.use_another_address_for_shipping.present?
          form.object.use_another_address_for_shipping = record.use_another_address_for_shipping
        end
      end

      form.object.build_billing_address unless form.object.billing_address
      form.object.build_shipping_address unless form.object.shipping_address

      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end
  end
end
