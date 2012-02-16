require "glysellin/engine"
require "glysellin/helpers"
require "glysellin/gateway"

module Glysellin
  mattr_accessor :app_root
  
  # Config vars, to be overriden from generated initializer file
  # -----------------
  
  # Defines if SKU must be automatically set on product save
  mattr_accessor :autoset_sku
  @@autoset_sku = true
  
  # To be filled if there are additional address fields to store in database
  mattr_accessor :additional_address_fields
  @@additional_address_fields = []
  
  # Giving it a lambda will override Order reference string generation method
  mattr_accessor :order_reference_generator
  @@order_reference_generator = nil
  
  # Order recap, show subtotal if no adjustements applied ?
  mattr_accessor :show_subtotal_if_identical
  @@show_subtotal_if_identical = false
  
  # Order recap, show shipping price if it doesn't cost anything ?
  mattr_accessor :show_shipping_if_zero
  @@show_shipping_if_zero = false
  
  mattr_accessor :contact_email
  @@contact_email = 'contact@example.com'
  
  # Payment statuses
  PAYMENT_STATUS_PENDING = 'pending'
  PAYMENT_STATUS_PAID = 'paid'
  PAYMENT_STATUS_CANCELED = 'canceled'
  
  # Config auto-yieldin'
  def self.config
    yield self
  end
  
end
