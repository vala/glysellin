module Glysellin
  module Cart
    class StateController < CartController
      def show
        state = params[:state]

        if @cart.available_states.include?(state)
          @cart.state = state.to_sym
        end

        redirect_to cart_path
      end
    end
  end
end
