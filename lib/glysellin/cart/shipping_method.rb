module Glysellin
  module Cart
    class ShippingMethod
      include ModelWrapper
      wraps :shipping_method, class_name: "Glysellin::ShippingMethod"
    end
  end
end