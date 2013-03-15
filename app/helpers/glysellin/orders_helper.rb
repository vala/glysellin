module Glysellin
  module OrdersHelper 
    def addresses_fields_for form
      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end
  end
end
