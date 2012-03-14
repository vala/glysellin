module Glysellin
  class PaymentMethod < ActiveRecord::Base
    include ModelInstanceHelperMethods
    self.table_name = 'glysellin_payment_methods'
    has_many :payments, :foreign_key => 'type_id'
    
    def self.gateway order_id, post_data
      order = Order.find(order_id)
      Glysellin.gateways[order.payment_method.slug].new(order, post_data)
    end
  end
end
