module Glysellin
  module Cart
    class AddressesController < CartController
      def update
        current_cart.update(params[:glysellin_cart_basket])

        if current_cart.valid?
          current_cart.addresses_filled!
          redirect_to cart_path
        else
          current_cart.state = "addresses"
          render "glysellin/cart/show"
        end
      end
    end
  end
end
