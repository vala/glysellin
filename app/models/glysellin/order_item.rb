module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order, inverse_of: :items

    attr_accessible :sku, :name, :eot_price, :vat_rate, :bundle, :price, :quantity

    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = %w(sku name eot_price vat_rate price)

    # Public: Create an item from product or bundle id
    #
    # @param [String] id The id string of the item
    # @param [Boolean] bundle If it's a bundle or just one product
    #
    # @return [OrderItem] The created order item
    def self.create_from_product_id id, quantity, bundle = false
      product = (bundle ? Bundle : Product).find_by_id(id)

      if product
        attrs = Hash[PRODUCT_ATTRIBUTES_FOR_ITEM.map { |key| [key, product.send(key)] }]
        attrs.merge!({ 'bundle' => bundle, 'price' => product.price, 'quantity' => quantity })
        # Create item from attributes
        OrderItem.new attrs
      end
    end
  end
end
