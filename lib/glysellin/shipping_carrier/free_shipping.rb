module Glysellin
  module ShippingCarrier
    class FreeShipping < Base
      register 'free-shipping', self

      def initialize order
      end

      def calculate
        0
      end
    end
  end
end