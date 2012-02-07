module Glysellin
  class ApplicationController < ActionController::Base
    before_filter :init
    
    protected
      # Init before filter
      def init
        get_customer!
      end
    
      # Get current customer
      def get_customer!
        @active_customer = user_signed_in? ? current_user.customer : Customer.new(:id => 0)
      end
  end
end
