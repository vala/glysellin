# CartController class borrowed from Piggybak's gem before we write our own one
# Piggyback : http://github.com/piggybak/piggybak
#
module Glysellin
  class CartController < ApplicationController
    before_filter :set_cart
    def show
      @cart.update_quantities
      # Display errors in flash
      flash[:error] = @cart.errors.join('<br>') if @cart.errors.length > 0
      update_cookie
    end

    def add
      @cart.add(params[:cart])
      update_cookie
      @product_added_to_cart = true
      render_cart_partial
    end

    def remove
      @cart.remove(params[:id])
      update_cookie set: true
      redirect_to cart_path
    end

    def clear
      @cart.empty!
      update_cookie
      redirect_to cart_path
    end

    def update
      @cart.update(params)
      update_cookie

      case
      when params[:submit_order]
        redirect_to from_cart_create_orders_path
      else
        redirect_to cart_path
      end
    end

    protected

    # Helper method to set cookie value
    def update_cookie options = {}
      if options[:set]
        response.set_cookie("glysellin.cart", { :value => @cart.serialize, :path => '/' })
      else
        cookies["glysellin.cart"] = { :value => @cart.serialize, :path => '/' }
      end
    end

    def render_cart_partial
      render partial: 'cart', locals: {
        cart: @cart
      }
    end

    def set_cart
      @cart = Cart.new(cookies["glysellin.cart"])
    end
  end
end