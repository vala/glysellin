class Glysellin::OrderAdminMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_paid_email order
    @order = order
    mail to: @order.email
  end
end
