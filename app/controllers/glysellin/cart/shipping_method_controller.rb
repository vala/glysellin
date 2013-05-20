module Glysellin
  module Cart
    class ShippingMethodController < CartController
      def update
        @cart.update(params[:glysellin_cart_basket])

        if @cart.valid?
          @cart.shipping_method_chosen!
          redirect_to cart_path
        else
          @cart.state = "choose_shipping_method"
          @cart.valid?
          render "glysellin/cart/show"
        end
      end
    end
  end
end
