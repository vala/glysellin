module Glysellin
  module Cart
    module Adjustment
      class ShippingMethod < Glysellin::Cart::Adjustment::Base
        register "shipping-method", self

        attributes :method_id

        def to_adjustment

        end
      end
    end
  end
end