module Glysellin
  module Cart
    class ProductsController < CartController
      def create
        current_cart.add(params[:cart])
        current_cart.products_added!
        @product_added_to_cart = true
        render_cart_partial
      end

      def update
        current_cart.set_quantity(params[:id], params[:quantity], override: true)

        product = current_cart.product(params[:id])
        variant, quantity = product.variant, product.quantity

        render json: {
          quantity: quantity,
          eot_price: number_to_currency(quantity * variant.eot_price),
          price: number_to_currency(quantity * variant.price)
        }.merge(totals_hash)
      end

      def destroy
        current_cart.remove(params[:id])
        redirect_to cart_path
      end

      def validate
        current_cart.update(params[:glysellin_cart_basket])
        current_cart.validated! if current_cart.valid?
        current_cart.customer = current_user
        redirect_to cart_path
      end
    end
  end
end