module Glysellin
  module Cart
    module Adjustment
      class DiscountCode < Glysellin::Cart::Adjustment::Base
        register "discount-code", self

        attributes :discount_code
        attr_accessor :valid

        def initialize cart, attributes
          super cart, attributes
          process_code
        end

        def process_code
          code = Glysellin::DiscountCode.from_code(discount_code)

          if code
            self.valid = true
            adjustment = code.to_adjustment(cart)
            self.name = adjustment[:name]
            self.value = adjustment[:value]
          else
            self.valid = false
          end
        end

        def to_adjustment

        end

        class << self
          def from_code str, cart
            if str.presence
              discount = self.new(cart, discount_code: str)
              discount.valid ? discount : nil
            end
          end
        end
      end
    end
  end
end