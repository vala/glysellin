require 'money'
require 'active_merchant'
require 'active_merchant/billing/integrations/action_view_helper'

ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)

module Glysellin
  module Gateway
    class PaypalIntegral < Glysellin::Gateway::Base
      include ActiveMerchant::Billing::Integrations
      register 'paypal-integral', self

      mattr_accessor :account
      @@account = ''

      # Production mode by default
      @@test = false

      attr_accessor :errors, :order
      
      def initialize order
        @order = order
        @errors = []
      end

      # Switch between test and prod modes for ActiveMerchant Paypal
      class << self
        def test=(val)
          ActiveMerchant::Billing::Base.mode = val ? :test : :production
          @@test = val
        end
      end

      def render_request_button
         {:partial => 'glysellin/payment_methods/paypal-integral', :locals => {:order => @order}}
      end

      # Launch payment processing
      def process_payment! post_data
        notification = Paypal::Notification.new(post_data)
        if notification.acknowledge
          begin
            if notification.complete?
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

      # The response returned within "render" method in the OrdersController#gateway_response method
      def response
        {:nothing => true}
      end
    end
  end
end