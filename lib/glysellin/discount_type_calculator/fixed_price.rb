module Glysellin
  module DiscountTypeCalculator
    class FixedPrice < Glysellin::DiscountTypeCalculator::Base
      register 'fixed-price', self

      def initialize order, value
        @order = order
        @value = value
      end

      def calculate
        @value
      end
    end
  end
end
