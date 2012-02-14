class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.glysellin.order_customer_mailer.send_order_created_email.subject
  #
  def send_order_created_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.glysellin.order_customer_mailer.send_order_paid_email.subject
  #
  def send_order_paid_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
