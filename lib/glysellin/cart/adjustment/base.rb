module Glysellin
  module Cart
    module Adjustment
      class Base
        include Serializable

        class << self
          attr_accessor :type

          def register type, klass
            @type = type
            Glysellin::Cart::Adjustment.types[type] = klass
          end

          def inherited subclass
            inheritable_accessors = @attrs.reject do |key|
              [:name, :value, :cart].include?(key)
            end

            subclass.attributes *inheritable_accessors
          end
        end

        attributes :name, :value, :type, :cart

        def initialize cart, attributes
          # Keep a reference to the cart to calculate discount
          self.cart = cart

          # Ensure type attribute is set
          attributes[:type] = self.class.type

          # Initialize attributes
          attributes.each do |key, value|
            self.public_send("#{ key }=", value)
          end
        end
      end
    end
  end
end