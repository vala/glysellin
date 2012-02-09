require "glysellin/engine"
require "glysellin/helpers"

module Glysellin
  mattr_accessor :app_root, :autoset_sku, :additional_address_fields, :order_reference_generator
  
  # Config vars
  @@autoset_sku = true
  @@additional_address_fields = []
  @@order_reference_generator = nil
  
  # Config auto-yieldin'
  def self.config
    yield self
  end
  
end
