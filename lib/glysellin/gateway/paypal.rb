require 'money'
require 'active_merchant'
require 'active_merchant/billing/integrations/action_view_helper'

ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)

module Glysellin
  module Gateway
    class PaypalIntegral < Glysellin::Gateway::Base
      register 'paypal-integral', self
      
      mattr_accessor :account
      @@account = ''
      
      mattr_accessor :test
      @@test = false
      
      attr_accessor :errors
      
      def initialize order, post_data
        ActiveMerchant::Billing::Base.mode = :test if @@test
          
        @notification = Paypal::Notification.new(post_data)
        @order = order
      end
      
      def process_payment!
        if @notification.acknowledge
          begin
            if @notification.complete?
              @order.pay!
            else
              @errors.push("Failed to verify Paypal's notification, please investigate")
            end
          rescue => e
            raise
          ensure
            @order.save
          end
        else
          false
        end
      end
      
      def response
        {:nothing => true}
      end
    end
  end
end