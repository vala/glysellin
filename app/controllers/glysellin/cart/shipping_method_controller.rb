module Glysellin
  module Cart
    class ShippingMethodController < CartController
      def update
        if params[:glysellin_cart_basket]
          @cart.update(params[:glysellin_cart_basket])
        end

        @cart.valid? ? @cart.shipping_method_chosen! : @cart.addresses_filled!

        redirect_to cart_path
      end
    end
  end
end
