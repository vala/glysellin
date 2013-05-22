module Glysellin
  module ShippingCarrier
    class FlatRate < Base
      register 'flat-rate', self

      def price_for_order order
        total_items = order.products.reduce(0) do |total, item|
          total + item.quantity
        end

        price_for_items_quantity(total_items)
      end

      def price_for_items_quantity quantity

      end
    end
  end
end