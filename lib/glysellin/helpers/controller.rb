module Glysellin
  module Helpers
    module Controller
      extend ActiveSupport::Concern

      included do
        helper_method :current_cart
      end

      protected

      def current_cart
        @cart ||= Glysellin::Cart.new(session["glysellin.cart"])
      end

      def reset_cart!
        @cart = Cart.new
        session.delete("glysellin.cart")
      end
    end
  end
end
