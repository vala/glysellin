module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order, inverse_of: :items

    attr_accessible :sku, :name, :eot_price, :vat_rate, :bundle, :price, :quantity

    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = %w(sku name eot_price vat_rate price)

    class << self
      # Public: Create an item from product or bundle id
      #
      # @param [String] id The id string of the item
      # @param [Boolean] bundle If it's a bundle or just one product
      #
      # @return [OrderItem] The created order item
      def create_from_product_id id, quantity
        product = Glysellin::Product.find_by_id(id)

        attrs = Hash[PRODUCT_ATTRIBUTES_FOR_ITEM.map { |key| [key, product.send(key)] }]

        # Auxiliary function for creating a product
        create_product = lambda do |product|
          OrderItem.new attrs.merge({
            'price' => product.price, 'quantity' => quantity
          })
        end

        if product.bundle?
          product.bundled_products.map { |prd| create_product.call(prd) }
        else
          [create_product.call(product)]
        end
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
