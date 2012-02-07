require "glysellin/engine"
require "glysellin/helpers"

module Glysellin
  mattr_accessor :app_root, :autoset_sku
  
  # Config vars
  @@autoset_sku = true
  
  # Config auto-yieldin'
  def self.config
    yield self
  end
  
end
