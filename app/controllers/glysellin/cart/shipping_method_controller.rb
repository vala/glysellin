module Glysellin
  module Cart
    class ShippingMethodController < CartController
      def update
        current_cart.update(params[:glysellin_cart_basket])

        if current_cart.valid?
          current_cart.shipping_method_chosen!
          redirect_to cart_path
        else
          current_cart.state = "choose_shipping_method"
          current_cart.valid?
          render "glysellin/cart/show"
        end
      end
    end
  end
end
