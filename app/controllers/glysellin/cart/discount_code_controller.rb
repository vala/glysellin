module Glysellin
  module Cart
    class DiscountCodeController < CartController
      def update
        current_cart.discount_code = params[:code]
        render json: totals_hash
      end
    end
  end
end
