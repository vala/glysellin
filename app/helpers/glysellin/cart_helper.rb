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
  end
end
