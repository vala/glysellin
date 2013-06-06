module Glysellin
  class PaymentMethod < ActiveRecord::Base
    self.table_name = 'glysellin_payment_methods'
    has_many :payments, :foreign_key => 'type_id'

    attr_accessible :name, :slug

    scope :ordered, order("name ASC")

    class << self
      def gateway_from_order_ref ref
        order = Order.find_by_ref(ref)
        gateway_for(order)
      end

      def gateway_from_raw_post gateway, raw_post
        order = Glysellin.gateways[gateway].parse_order_id(raw_post)
        gateway_for(order)
      end

      def gateway_for order
        Glysellin.gateways[order.payment_method.slug].new(order)
      end
    end

    # Get the payment request button HTML for the specified order
    #
    # @param [Order] order The order to get the payment request for
    #
    # @return [String] The request button HTML
    def request_button order
      g = Glysellin.gateways[order.payment_method.slug].new(order)
      g.render_request_button
    end
  end
end
