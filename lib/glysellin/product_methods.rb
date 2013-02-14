module Glysellin
  module ProductMethods
    extend ActiveSupport::Concern

    module ClassMethods
      attr_writer :bundle_attributes

      def bundle_attributes
        @bundle_attributes ||= {}
      end

      def bundle_attribute attribute, &block
        # Store block to be called to retrieve
        self.bundle_attributes[attribute.to_sym] = block

        class_eval <<-CLASS, __FILE__, __LINE__
          def bundle_#{ attribute }
            if bundled_products.length > 0
              self.class.bundle_attributes[:#{ attribute }].call(self)
            end
          end

          def #{ attribute }
            value = super
            value = bundle_#{ attribute } if value == nil
            value
          end

          def #{ attribute }=(value)
            super(value) if value != bundle_#{ attribute }
          end
        CLASS
      end
    end

    # SKU generation helper
    #
    # @return [String] The generated SKU
    def generate_sku
      # Get last product only selecting id
      last_item = self.class.select(:id).order('id DESC').first
      # Generate SKU from the last product id we got,
      # or appending "1" if there's no product
      sku = (last_item ? (last_item.id + 1).to_s : '1')
      sku += self.name.parameterize
    end

    # Checks if a product is a bundle of other sub products
    #
    # @return  [true, false]
    def bundle?
      false
      # bundled_products.length > 0
    end

    # Gives calculable vat rate
    #
    # Example :
    #    If vat_rate is set to 19.6%, returns back 1.196
    #
    # @return  [Float]  The processed VAT rate
    def vat_ratio
      1 + vat_rate / 100
    end
  end
end