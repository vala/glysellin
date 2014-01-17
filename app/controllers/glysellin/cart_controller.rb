# CartController class borrowed from Piggybak's gem before we write our own one
# Piggyback : http://github.com/piggybak/piggybak
#
module Glysellin
  class CartController < ApplicationController
    include ActionView::Helpers::NumberHelper

    before_filter :set_cart

    def show
      @cart.update_quantities
      # Display errors in flash
      flash_errors
      update_cookie
    end

    def add
      @cart.add(params[:cart])
      update_cookie
      @product_added_to_cart = true
      render_cart_partial
    end

    def update_quantity
      id = params[:product_id]
      @cart.set_quantity(id, params[:quantity], override: true)
      update_cookie

      item = @cart.product(id)
      product, quantity = item[:product], item[:quantity]
      render json: {
        quantity: quantity,
        eot_price: number_to_currency(quantity * product.eot_price),
        price: number_to_currency(quantity * product.price)
      }.merge(totals_hash)
    end

    def update_discount_code
      puts "assign discount code"
      @cart.discount_code = params[:discount_code]
      puts "update cookie"
      update_cookie
      puts "render partial"
      render json: totals_hash
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
      flash_errors
      update_cookie

      case
      when @cart.errors.length == 0 && (Glysellin.async_cart || params[:submit_order])
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
      set_cart
    end

    def render_cart_partial
      render partial: 'cart', locals: {
        cart: @cart
      }
    end

    def flash_errors
      flash[:error] = @cart.errors.join('<br>') if @cart.errors.length > 0
    end

    def set_cart
      @cart ||= Cart.new(cookies["glysellin.cart"])
    end

    def totals_hash
      {
        adjustment_name: @cart.adjustment_name,
        adjustment_value: number_to_currency(@cart.adjustment_value),
        total_eot_price: number_to_currency(@cart.total_eot_price),
        total_price: number_to_currency(@cart.total_price),
        eot_subtotal: number_to_currency(@cart.eot_subtotal),
        subtotal: number_to_currency(@cart.subtotal)
      }
    end
  end
end