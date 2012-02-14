class Glysellin::OrderAdminMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.glysellin.order_admin_mailer.send_order_paid_email.subject
  #
  def send_order_paid_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
