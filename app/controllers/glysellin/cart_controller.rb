# CartController class borrowed from Piggybak's gem before we write our own one
# Piggyback : http://github.com/piggybak/piggybak
#
module Glysellin
  class CartController < ApplicationController
    def show
      @cart = Cart.new(cookies["glysellin.cart"])
      @cart.update_quantities
      update_cookie @cart.to_cookie
    end

    def add
      update_cookie Cart.add(cookies["glysellin.cart"], params[:cart])
      render_cart_partial
    end

    def remove
      update_cookie Cart.remove(cookies["glysellin.cart"], params[:item]), set: true
      render_cart_partial
    end

    def clear
      update_cookie ''
      render_cart_partial
    end

    def update
      update_cookie Cart.update(cookies["glysellin.cart"], params)
      redirect_to glysellin.cart_path
    end

    protected

    # Helper method to set cookie value
    def update_cookie value, options = {}
      if options[:set]
        response.set_cookie("glysellin.cart", { :value => value, :path => '/' })
      else
        cookies["glysellin.cart"] = { :value => value, :path => '/' }
      end
    end

    def render_cart_partial
      render partial: 'cart', locals: {
        cart: Cart.new(cookies["glysellin.cart"])
      }
    end
  end
end
