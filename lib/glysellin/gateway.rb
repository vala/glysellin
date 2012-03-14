if File.exists? 'glysellin/engine/routes'
  require 'glysellin/gateway/base'
  require 'glysellin/gateway/paypal_integral'
else
  require File.expand_path('../gateway/base', __FILE__)
  require File.expand_path('../gateway/paypal_integral', __FILE__)
end

module Glysellin  
  module Gateway
  end
end
