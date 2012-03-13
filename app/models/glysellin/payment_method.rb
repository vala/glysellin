module Glysellin
  class PaymentMethod < ActiveRecord::Base
    include ModelInstanceHelperMethods
    self.table_name = 'glysellin_payment_methods'
    has_many :payments, :foreign_key => 'type_id'
    
    def self.gateway params
      order = Order.find(params[:goid])
      Glysellin.gateways[order.payment_method.slug].new(order, params)
    end
  end
end
