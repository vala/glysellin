module Glysellin
  class MainController < ::ApplicationController
    before_filter :glysellin_main_init

    protected
      # Init before filter
      def glysellin_main_init
        get_customer!
      end

      # Get current customer
      def get_customer!
        @active_customer = user_signed_in? ? current_user : User.new
      end

      def current_cart
        @cart ||= Glysellin::Cart.new(request.cookies["glysellin.cart"])
      end
  end
end
