# encoding: utf-8

module Glysellin
  self.config do |config|
    # User model must be set in order to bind customers to authenticable users
    #   default: 'User'
    # config.user_class_name = 'User'

    # Add additional fields to address model
    #   default: []
    # config.additional_address_fields = [:email, :age]

    # Change the way order billing references are generated
    # Reproducting default generator would be this :
    # config.order_reference_generator = lambda { |order| "#{ Time.now.strftime('%Y%m%d%H%M') }-#{ order.id }" }

    # Configure your shop name, used to send e-mails
    config.shop_name = 'My super shop'

    # Configure sender e-mail address used when sending e-mails to customers and
    # to admins
    config.contact_email = 'change-me-in-glysellin-initialize-file@example.com'

    # Configure recipient e-mail address used to send orders when completed
    config.admin_email = 'change-me-in-glysellin-initialize-file@example.com'

    # Set default VAT rate for products when it is not set in db
    config.default_vat_rate = 19.6

    # Default product weight for shipping rate calculation, expressed in kilograms
    # Defaults to 0. For 100g, use value : 0.1
    #
    # config.default_product_weight = 0.1

    # Allows creating fake accounts for customers with automatic random
    # password generation
    # Defaults to true
    #
    # config.allow_anonymous_orders = true

    # Sends an automatic e-mail to the shop admin when a new order with
    # check payment method is placed
    # Defaults to true
    #
    # config.send_email_on_check_order_placed = true

    # Set steps order to be used while using automatic order process
    #
    # config.step_routes = {
    #   created: ORDER_STEP_ADDRESS,
    #   filling_address: ORDER_STEP_ADDRESS,
    #   address: ORDER_STEP_SHIPPING_METHOD,
    #   shipping_method_chosen: ORDER_STEP_PAYMENT_METHOD,
    #   payment_method_chosen: ORDER_STEP_PAYMENT
    # }

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

    # Product images paperclip styles, defaults are listed below
    # config.product_images_styles = {
    #   :thumb => '100x100#',
    #   :content => '300x300'
    # }

    # Config sogenactif account
    # config.gateways['atos'].config do |atos|
    #   atos.merchant_id = '0123012302130120'
    #   atos.pathfile_path = Rails.root.join('vendor', 'atos', 'param', 'pathfile')
    #   atos.bin_path = Rails.root.join('bin')
    #   atos.merchant_country = 'fr'
    #   atos.capture_mode = 'AUTHOR_CAPTURE'
    #   atos.capture_days = nil
    #   atos.activate_logger = false
    # end

    # config.gateways['check'].config do |c|
    #
    #   # Check paying notes description (on order recap page)
    #   #
    #   # First way : Configure check order and check destination
    #   c.checks_order = "Order me nasty !"
    #   c.checks_destination = "Check services / your addres here ..."
    #   # Second way : Use your own description wraped in a lambda which will
    #   # be passed the order
    #   c.check_payment_description = lambda { |order| I18n.t(:check_payment_instructions, order_ref: order.ref) }
    #
    # end
  end

  # Decorators management
  #
  # This is the behavior found in Rails 4, so to start sticking with future
  # conventions, you can uncomment the following lines to enable you to create
  # simple class_eval decorators in :
  #
  # Example :
  #
  #    # app/decorators/models/glysellin/product_decorator.rb
  #    Glysellin::Product.class_eval do
  #      def self.search query
  #        where('name LIKE ?', query)
  #      end
  #    end
  #
  # ======================================================================
  #
  # Dir["#{ Rails.root }/app/decorators/*/glysellin/*_decorator.rb"].each do |decorator|
  #   constant = decorator.split(/decorators\/.*?\/glysellin\//).pop.gsub(/_decorator\.rb/, '').camelize.to_sym
  #   autoload constant, decorator
  # end
end