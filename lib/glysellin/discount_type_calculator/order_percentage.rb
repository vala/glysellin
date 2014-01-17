module Glysellin
  module DiscountTypeCalculator
    class OrderPercentage < Glysellin::DiscountTypeCalculator::Base
      register 'order-percentage', self

      def initialize order, value
        @order = order
        @value = (value.to_f / 100.0) # Convert to percentage
      end

      def calculate
        @order.subtotal * @value
      end
    end
  end
end
