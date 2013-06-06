module Glysellin
  module Cart
    class Customer
      include ModelWrapper
      wraps :user, class_name: "::User",
        attributes: [
          :id, :email, :password, :password_confirmation, :billing_address,
          :shipping_address, :use_another_address_for_shipping
        ]

      def initialize attributes = {}
        if attributes.is_a?(User) && attributes.id
          @id = attributes.id
          @user = attributes
        elsif (id = attributes["id"].presence)
          @id = id
          @user = User.find(id)
        else
          super attributes
        end
      end

      def as_json
        # raise "As json on customer = #{ id.inspect }" if id
        if id
          { id: user.id }
        else
          %w(email password password_confirmation).reduce({}) do |hash, attr|
            hash[attr] = public_send(attr)
            hash
          end
        end
      end
    end
  end
end