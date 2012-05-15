module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order
    
    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = ['sku', 'name', 'df_price', 'vat_rate', 'price']
    
    # Public: Create an item from product or bundle slug
    #
    # @param [String] slug The slug string of the item
    # @param [Boolean] bundle If it's a bundle or just one product
    #
    # @return [OrderItem] The created order item
    def self.create_from_product_slug slug, bundle = false
      product = (bundle ? Product : Bundle).find_by_slug(slug)
      new product.attributes.reject {|k,v| !PRODUCT_ATTRIBUTES_FOR_ITEM.include?(k)}.merge({ bundle: bundle }) if product
    end
  end
end
