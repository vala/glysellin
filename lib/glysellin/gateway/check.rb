module Glysellin
  module Gateway
    class Check < Glysellin::Gateway::Base
      register 'check', self

      mattr_accessor :checks_order
      @@checks_order = ""
      mattr_accessor :checks_destination
      @@checks_destination = ""

      mattr_accessor :check_payment_description
      @@check_payment_description = lambda { |order| I18n.t('glysellin.labels.payment_methods.check.send_your_check_text', :order_ref => order.ref, :check_order => @@checks_order, :check_destination => @@checks_destination).html_safe }

      attr_accessor :errors, :order

      def initialize order
        @order = order
        @errors = []
      end

      def render_request_button
         { :text => @@check_payment_description.call(@order) }
      end

      def process_payment! post_data
        true
      end

      def response
        { :nothing => true }
      end
    end
  end
end