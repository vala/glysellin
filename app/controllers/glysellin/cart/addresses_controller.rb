module Glysellin
  module Cart
    class AddressesController < CartController
      def update
        @cart.update(params[:glysellin_cart_basket])

        if @cart.valid?
          @cart.addresses_filled!
          redirect_to cart_path
        else
          @cart.state = "addresses"
          render "glysellin/cart/show"
        end
      end
    end
  end
end
