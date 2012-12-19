module Glysellin
  class OrderObserver < ActiveRecord::Observer
    
    def after_payment order
      puts "### AFTER PAYMENT"
      puts order.inspect
      # This will be run once the payment method has been chosen
    end

    def after_paid order
      puts "### AFTER PAID"
      puts order.inspect
      # This will be run once the order has been paid
    end

  end
end