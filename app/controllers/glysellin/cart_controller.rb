module Glysellin
  class CartController < ApplicationController
    include ActionView::Helpers::NumberHelper

    before_filter :set_cart
    after_filter :update_cart_in_session

    def show
      current_cart.update_quantities!
    end

    def destroy
      reset_cart!
      redirect_to cart_path
    end

    protected

    def render_cart_partial
      render partial: 'cart', locals: { cart: current_cart }
    end

    def set_cart
      @states = current_cart.available_states
    end

    # Helper method to set cookie value
    def update_cart_in_session options = {}
      if current_cart.errors.any?
        flash[:error] =
          t("glysellin.errors.cart.state_transitions.#{ current_cart.state }")
      end

      session["glysellin.cart"] = current_cart.serialize
    end

    def totals_hash
      adjustment = current_cart.discount

      discount_name = adjustment.name rescue nil
      discount_value = number_to_currency(adjustment.value) rescue nil

      {
        discount_name: discount_name,
        discount_value: discount_value,
        total_eot_price: number_to_currency(current_cart.total_eot_price),
        total_price: number_to_currency(current_cart.total_price),
        eot_subtotal: number_to_currency(current_cart.eot_subtotal),
        subtotal: number_to_currency(current_cart.subtotal)
      }
    end
  end
end