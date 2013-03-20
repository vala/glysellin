module Glysellin
  module Cart
    class Customer
      include ModelWrapper
      wraps :user, class_name: "::User",
        attributes: [:id, :email, :password, :password_confirmation]

      attr_accessor :id

      def initialize attributes = {}
        if attributes.is_a?(User) && attributes.id
          @id = attributes.id
          @user = attributes
        else
          super attributes
        end
      end

      def as_json
        if user.new_record?
          %w(email password password_confirmation).reduce({}) do |hash, attr|
            hash[attr] = public_send(attr)
            hash
          end
        else
          { id: user.id }
        end
      end
    end
  end
end