require 'test_helper'

class Glysellin::OrderAdminMailerTest < ActionMailer::TestCase
  test "send_order_paid_email" do
    mail = Glysellin::OrderAdminMailer.send_order_paid_email
    assert_equal "Send order paid email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
