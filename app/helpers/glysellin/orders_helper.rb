module Glysellin
  module OrdersHelper 
    def addresses_fields_for form
      form.object.build_billing_address unless form.object.billing_address
      form.object.build_shipping_address unless form.object.shipping_address
      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end
  end
end
