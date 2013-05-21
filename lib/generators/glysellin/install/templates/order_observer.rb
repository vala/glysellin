class OrderObserver < ActiveRecord::Observer
  observe Glysellin::Order

  def after_paid order, transition
    # This will be run once the order has been paid
  end

  def after_shipped order, transition
    # This will be run once the order has been shipped
  end

end