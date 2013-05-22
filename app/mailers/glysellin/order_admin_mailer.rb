class Glysellin::OrderAdminMailer < ActionMailer::Base
  default from: Glysellin.contact_email, to: Glysellin.admin_email

  def send_order_paid_email order
    @order = order
    mail(
      subject: Glysellin.mailer_subjects.call[:admin][:send_order_paid_email]
    )
  end

  def send_check_order_created_email order
    @order = order
    mail(
      subject: Glysellin.mailer_subjects.call[:admin][:send_check_order_created_email]
    )
  end
end
