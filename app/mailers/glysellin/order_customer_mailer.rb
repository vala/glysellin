class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_created_email order
    @order = order
    mail to: @order.email
  end

  def send_order_paid_email order
    @order = order
    mail to: @order.email
  end

  def send_order_shipped_email order
    @order = order
    mail to: @order.email
  end
end
