module Glysellin
  module Cart
    class StateController < CartController
      def show
        state = params[:state]
        @cart.state = state.to_sym if @cart.available_states.include?(state)
        redirect_to cart_path
      end
    end
  end
end
