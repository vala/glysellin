module Glysellin
  module Cart
    class StateController < CartController
      def show
        state = params[:state]

        if current_cart.available_states.include?(state)
          current_cart.state = state.to_sym
        end

        redirect_to cart_path
      end
    end
  end
end
