module Glysellin
  class OrderObserver < ActiveRecord::Observer
    
    def after_payment order
      # This will be run once the order has been paid
    end

    def after_shipping order
      # This will be run once the order gets in shipping status
    end

    def after_shipped order
      # This will be run once the order has been shipped
    end

    def after_update order
      if order.status_changed?
        after_payment(order) if order.paid?
        after_shipping(order) if order.shipping?
        after_shipped(order) if order.shipped?
      end
    end
  end
end