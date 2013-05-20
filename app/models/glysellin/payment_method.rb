module Glysellin
  class PaymentMethod < ActiveRecord::Base
    include ModelInstanceHelperMethods
    self.table_name = 'glysellin_payment_methods'
    has_many :payments, :foreign_key => 'type_id'

    attr_accessible :name, :slug

    scope :ordered, order("name ASC")

    # Get the gateway object corresponding to the current payment from
    #   the options hash passed as parameters
    #
    # @param [Hash] options A hash containing
    #
    # @return [Gateway::Base] The gateway used for the payment method
    #
    # @example Get from gateway and post data from a controller
    #   PaymentMethod.gateway({
    #     gateway: 'paypal-integral',
    #     raw_post: request.raw_post
    #   })
    #
    def self.gateway options = {}
      order = Order.find(options[:order_id] ? options[:order_id] : Glysellin.gateways[options[:gateway]].parse_order_id(options[:raw_post]))
      Glysellin.gateways[order.payment_method.slug].new(order)
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
