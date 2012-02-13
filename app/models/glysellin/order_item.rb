module Glysellin
  class OrderItem < ActiveRecord::Base
    self.table_name = 'glysellin_order_items'
    belongs_to :order
    
    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = ['sku', 'name', 'df_price', 'vat_rate', 'price']
    
    def self.create_from_product_slug slug
      new Product.find_by_slug(slug).attributes.reject {|k,v| !PRODUCT_ATTRIBUTES_FOR_ITEM.include?(k)}
    end
  end
end
