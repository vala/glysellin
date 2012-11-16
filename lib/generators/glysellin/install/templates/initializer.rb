# encoding: utf-8

Glysellin.config do |config|
  # User model must be set in order to bind customers to authenticable users
  #   default: 'User'
  # config.user_class_name = 'User'

  # Add additional fields to address model
  #   default: []
  # config.additional_address_fields = [:email, :age]

  # Change the way order billing references are generated
  # Reproducting default generator would be this :
  # config.order_reference_generator = lambda { |order| "#{ Time.now.strftime('%Y%m%d%H%M') }-#{ order.id }" }

  config.contact_email = 'change-me-in-glysellin-initialize-file@example.com'
  config.shop_name = 'My super shop'
  config.admin_email = 'change-me-in-glysellin-initialize-file@example.com'

  # Set default VAT rate for products when it is not set in db
  config.default_vat_rate = 19.6

  # Set steps order to be used while using automatic order process
  # config.order_steps_process [
  #   Glysellin::ORDER_STEP_CART,
  #   Glysellin::ORDER_STEP_ADDRESS,
  #   Glysellin::ORDER_STEP_PAYMENT_METHOD,
  #   Glysellin::ORDER_STEP_PAYMENT
  # ]

  # Change presence validation of Address fields
  #   default: *[:first_name, :last_name, :address, :zip, :city, :country]
  # config.address_presence_validation_keys = *[:first_name, :last_name, :address, :zip, :city, :country]

  # Config paypal account
  # config.gateways['paypal-integral'].config do |pp|
  #     if Rails.env == 'development'
  #       pp.account =  'paypal-test-account@example.com'
  #       pp.test = true
  #     else
  #       pp.account = 'paypal-account@example.com'
  #     end
  #   end

  # Config mercanet account
  # config.gateways['mercanet'].config do |m|
  #   m.merchant_id = '0123012302130120'
  #   m.pathfile_path = Rails.root.join('vendor', 'mercanet', 'param', 'pathfile')
  #   m.bin_path = Rails.root.join('vendor', 'mercanet', 'bin', 'static')
  # end

  # Config sogenactif account
  # config.gateways['sogenactif'].config do |s|
  #   s.merchant_id = '0123012302130120'
  #   s.pathfile_path = Rails.root.join('vendor', 'mercanet', 'param', 'pathfile')
  #   s.bin_path = Rails.root.join('vendor', 'mercanet', 'bin', 'static')
  # end

  # config.gateways['check'].config do |c|
  #   c.checks_order = "Order me nasty !"
  #   c.checks_destination = "Check services / your addres here ..."
  # end
end
