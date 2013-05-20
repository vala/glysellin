module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order, inverse_of: :products

    attr_accessible :sku, :name, :eot_price, :vat_rate, :bundle, :price,
      :quantity, :weight

    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = %w(sku name eot_price vat_rate price weight)

    class << self
      # Create an item from product or bundle id
      #
      # @param [String] id The id string of the item
      # @param [Boolean] bundle If it's a bundle or just one product
      #
      # @return [OrderItem] The created order item
      def build_from_product id, quantity
        product = Glysellin::Variant.find_by_id(id)

        attrs = PRODUCT_ATTRIBUTES_FOR_ITEM.map do |key|
          [key, product.public_send(key)]
        end

        OrderItem.new(Hash[attrs].merge('quantity' => quantity))
      end
    end

    def total_eot_price
      quantity * eot_price
    end

    def total_price
      quantity * price
    end
  end
end
