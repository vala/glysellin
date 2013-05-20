module Glysellin
  module Cart
    class Product
      attr_accessor :variant, :quantity

      def initialize attrs
        @variant = Glysellin::Variant.find(attrs[:id])
        @quantity = attrs[:quantity]
      end

      def as_json
        { id: variant.id, quantity: quantity }
      end
    end
  end
end