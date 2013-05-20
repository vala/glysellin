module Glysellin
  module Cart
    class Address
      include ModelWrapper
      wraps :embed_address, class_name: "Glysellin::Address"

      def as_json
        attributes.reject do |attr, _|
          key = attr.to_s
          %w(id created_at updated_at activated).include?(key) ||
            key.match(/addressable/)
        end
      end
    end
  end
end