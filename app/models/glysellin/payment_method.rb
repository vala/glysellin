module Glysellin
  class PaymentMethod < ActiveRecord::Base
    include ModelInstanceHelperMethods
    self.table_name = 'glysellin_payment_methods'
    has_many :payments, :foreign_key => 'type_id'
    
    def self.gateway options = {}
      order = Order.find(options[:order_id] ? options[:order_id] : Glysellin.gateways[order.payment_method.slug].parse_order_id(options[:raw_post]))
      Glysellin.gateways[order.payment_method.slug].new(order)
    end
    
    def request_button order
      g = Glysellin.gateways[order.payment_method.slug].new(order)
      g.render_request_button
    end    
  end
end
