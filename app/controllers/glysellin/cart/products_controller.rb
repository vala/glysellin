module Glysellin
  module Cart
    class ProductsController < CartController
      def create
        @cart.add(params[:cart])
        @cart.products_added!
        @product_added_to_cart = true
        render_cart_partial
      end

      def update
        @cart.set_quantity(params[:id], params[:quantity], override: true)

        product = @cart.product(params[:id])
        variant, quantity = product.variant, product.quantity

        render json: {
          quantity: quantity,
          eot_price: number_to_currency(quantity * variant.eot_price),
          price: number_to_currency(quantity * variant.price)
        }.merge(totals_hash)
      end

      def destroy
        @cart.remove(params[:id])
        redirect_to cart_path
      end

      def validate
        @cart.update(params[:glysellin_cart_basket])
        @cart.validated! if @cart.filled? && @cart.valid?
        redirect_to cart_path
      end
    end
  end
end