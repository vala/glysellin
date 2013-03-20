module Glysellin
  module Cart
    class AddressesController < CartController
      def update
        @cart.update(params[:glysellin_cart_basket])
        @cart.valid? ? @cart.addresses_filled! : @cart.validated!
        redirect_to cart_path
      end
    end
  end
end
