class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_created_email order
    @order = order
    mail(
      to: @order.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_created_email]
    )
  end

  def send_order_paid_email order
    @order = order
    mail(
      to: @order.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_paid_email]
    )
  end

  def send_order_shipped_email order
    @order = order
    mail(
      to: @order.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_shipped_email]
    )
  end
end
