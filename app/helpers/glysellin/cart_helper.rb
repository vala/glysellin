module Glysellin
  module CartHelper
    def add_to_cart_form product, options = {}
      # Default to remote form
      options[:remote] = true unless options[:remote] == false
      # Render actual form
      render partial: 'glysellin/products/add_to_cart', locals: {
        product: product,
        options: options
      }
    end

    def split_order_item_details product
      if product.is_a? OrderItem
        [product, product.quantity]
      else
        [product[:product], product[:quantity]]
      end
    end
  end
end
