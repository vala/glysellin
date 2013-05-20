module Glysellin
  module Cart
    class PaymentMethodController < CartController
      def update
        @cart.update(params[:glysellin_cart_basket])

        if @cart.valid?
          @cart.payment_method_chosen!
          redirect_to cart_path
        else
          @cart.state = "choose_payment_method"
          render "glysellin/cart/show"
        end
      end
    end
  end
end
