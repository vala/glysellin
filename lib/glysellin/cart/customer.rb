module Glysellin
  module Cart
    class Customer
      include ModelWrapper
      wraps :user, class_name: "::User"

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