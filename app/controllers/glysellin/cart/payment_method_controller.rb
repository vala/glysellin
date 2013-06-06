module Glysellin
  module Cart
    class PaymentMethodController < CartController
      def update
        current_cart.update(params[:glysellin_cart_basket])

        if current_cart.valid?
          current_cart.payment_method_chosen!
          redirect_to cart_path
        else
          current_cart.state = "choose_payment_method"
          render "glysellin/cart/show"
        end
      end
    end
  end
end
