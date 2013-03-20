module Glysellin
  module Cart
    class PaymentMethodController < CartController
      def update
        @cart.update(params[:glysellin_cart_basket])

        @cart.valid? ?
          @cart.payment_method_chosen! :
          @cart.shipping_method_chosen!

        redirect_to cart_path
      end
    end
  end
end
