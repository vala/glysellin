require "glysellin/engine"
require "glysellin/helpers"
require "glysellin/gateway"
require "glysellin/product_methods"
require "glysellin/products_list"
require "glysellin/cart"

module Glysellin
  # Public: Main app root to be defined inside engine initialization process
  #   so we can refer to it from inside the lib
  mattr_accessor :app_root

  ################################################################
  #
  # Config vars, to be overriden from generated initializer file
  #
  ################################################################

  # Status const to be used to define order step to cart shopping
  ORDER_STEP_CART = 'cart'
  # Status const to be used to define order step to address
  ORDER_STEP_ADDRESS = 'addresses'
  # Status const to be used to define order step to defining payment method
  ORDER_STEP_PAYMENT_METHOD = 'payment_method'
  # Status const to be used to define order step to payment
  ORDER_STEP_PAYMENT = 'payment'

  ################################################################
  #
  # Config vars, to be overriden from generated initializer file
  #
  ################################################################

  # Public: Defines which user class will be used to bind Customer model to an
  #   authenticable user
  mattr_accessor :user_class_name
  @@user_class_name = 'User'

  # Public: Defines if SKU must be automatically set on product save
  mattr_accessor :autoset_sku
  @@autoset_sku = true

  # Public: Defines which fields must be present when validating an
  #    Address model
  mattr_accessor :address_presence_validation_keys
  @@address_presence_validation_keys = [:first_name, :last_name, :address, :zip, :city, :country]

  # Public: Has to be filled if there are additional address fields to
  #   store in database
  mattr_accessor :additional_address_fields
  @@additional_address_fields = []

  # Public: Giving it a lambda will override Order reference
  #   string generation method
  mattr_accessor :order_reference_generator
  @@order_reference_generator = nil

  # Public: Defines if we will show the subtotal field in Order recaps if
  #   no adjustements are applied to the Order price
  mattr_accessor :show_subtotal_if_identical
  @@show_subtotal_if_identical = false

  # Public: Define if we should show shipping price if it is equal to zero
  mattr_accessor :show_shipping_if_zero
  @@show_shipping_if_zero = false

  # Public: The sender e-mail address used in order e-mails
  mattr_accessor :contact_email
  @@contact_email = 'orders@example.com'

  # Public: The destination e-mail for order validations and other
  #   admin related e-mails
  mattr_accessor :admin_email
  @@admin_email = 'admin@example.com'

  # Public: Public shop name used when referencing it inside
  #   the app and e-mails
  mattr_accessor :shop_name
  @@shop_name = 'Example Shop Name'

  mattr_accessor :default_vat_rate
  @@default_vat_rate = 19.6

  mattr_accessor :step_routes
  @@step_routes = {
    created: ORDER_STEP_ADDRESS,
    filling_address: ORDER_STEP_ADDRESS,
    address: ORDER_STEP_PAYMENT_METHOD,
    payment: ORDER_STEP_PAYMENT
  }


  mattr_accessor :allow_anonymous_orders
  @@allow_anonymous_orders = true

  # Public: Permits using config block in order to set
  #   Glysellin module attributes
  #
  # Examples
  #
  #   Glysellin.config do |c|
  #     c.contact_email = 'orders@myshop.com'
  #   end
  #
  # Returns nothing
  def self.config
    yield self
  end

  # Load helpers
  ActionController::Base.send(:include, Helpers)
end
