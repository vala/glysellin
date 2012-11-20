module Glysellin
  module Helpers
    module Views
      extend ActiveSupport::Concern

      included do
        helper_method :flatten_products
      end

      # Creates a list of all items and replaces bundles by their sub items
      # Flattens only one level of sub products
      #
      # @param  [Array]  products  The products array to flatten
      #
      # @return [Array]  The flattened list of products
      def flatten_products products
        products.reduce([]) do |list, product|
          if product.bundle?
            list += product.bundled_products
          else
            list << product
          end
        end
      end
    end
  end
end