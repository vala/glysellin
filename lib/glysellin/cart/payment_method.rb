module Glysellin
  module Cart
    class PaymentMethod
      include ModelWrapper
      wraps :payment_method, class_name: "Glysellin::PaymentMethod"
    end
  end
end