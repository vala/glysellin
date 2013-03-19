module Glysellin
  module OrdersHelper 

    # Generates Orderer form fields
    #
    # @param form Form object to which the fields are added
    # @param record Optional model object that implements Glysellin::Orderer
    #
    def addresses_fields_for form, record = nil
      if record
        %w(billing_address shipping_address).each do |attribute|
          attributes = record.send("#{attribute}").attributes.select { |key, value| Glysellin::Address.accessible_attributes.include?(key) }
          form.object.build_billing_address(attributes) unless form.object.send(attribute).present? && form.object.send(attribute).id.present?
        end
        form.object.use_another_address_for_shipping = record.use_another_address_for_shipping unless form.object.use_another_address_for_shipping.present?
      end

      form.object.build_billing_address unless form.object.billing_address
      form.object.build_shipping_address unless form.object.shipping_address
      
      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end
  end
end
