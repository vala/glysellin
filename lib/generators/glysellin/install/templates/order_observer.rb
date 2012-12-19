class OrderObserver < ActiveRecord::Observer
  observe Glysellin::Order 

  def after_set_payment order, transition
    # This will be run once the payment method has been chosen
  end

  def after_set_paid order, transition
    # This will be run once the order has been paid
  end

end