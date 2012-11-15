module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order, inverse_of: :items

    attr_accessible :sku, :name, :eot_price, :vat_rate, :bundle, :price

    # The attributes we getch from a product to build our order item
    @@product_attributes_for_item = ['sku', 'name', 'eot_price', 'vat_rate', 'price']

    # Public: Create an item from product or bundle id
    #
    # @param [String] id The id string of the item
    # @param [Boolean] bundle If it's a bundle or just one product
    #
    # @return [OrderItem] The created order item
    def self.create_from_product_id id, bundle = false
      product = (bundle ? Bundle : Product).find_by_id(id)

      if product
        new product.attributes.select do |k,v|
          @@product_attributes_for_item.include?(k)
        end.merge({ bundle: bundle, price: product.price })
      end
    end
  end
end
