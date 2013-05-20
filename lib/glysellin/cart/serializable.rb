module Glysellin
  module Cart
    module Serializable
      extend ActiveSupport::Concern

      def as_json
        self.class.attrs.reduce({}) do |hash, attribute|
          hash[attribute] = send(attribute)
          hash
        end
      end

      module ClassMethods
        attr_writer :attrs

        def attributes *attrs
          self.attrs += attrs

          attrs.each do |attribute|
            attr_accessor attribute
          end
        end

        def attrs
          @attrs ||= []
        end
      end
    end
  end
end