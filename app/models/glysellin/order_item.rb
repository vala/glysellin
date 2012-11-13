module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order

    attr_accessible :sku, :name, :eot_price, :vat_rate, :bundle, :price

    # The attributes we getch from a product to build our order item
    @@product_attributes_for_item = ['sku', 'name', 'eot_price', 'vat_rate', 'price']

    # Public: Create an item from product or bundle slug
    #
    # @param [String] slug The slug string of the item
    # @param [Boolean] bundle If it's a bundle or just one product
    #
    # @return [OrderItem] The created order item
    def self.create_from_product_slug slug, bundle = false
      product = (bundle ? Bundle : Product).find_by_slug(slug)
      new product.attributes.select {|k,v| @@product_attributes_for_item.include?(k)}.merge({ bundle: bundle, price: product.price }) if product
    end
  end
end
