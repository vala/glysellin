module Glysellin
  module Cart
    module Adjustment
      class ShippingMethod < Glysellin::Cart::Adjustment::Base
        register "shipping-method", self

        attributes :shipping_method_id

        attr_accessor :valid

        def initialize cart, attributes = {}
          super cart, attributes

          adjustment = cart.shipping_method.to_adjustment(cart)

          if adjustment[:value]
            self.valid = true
            self.name = adjustment[:name]
            self.value = adjustment[:value]
          else
            self.valid = false
          end
        end

        def to_adjustment

        end
      end
    end
  end
end