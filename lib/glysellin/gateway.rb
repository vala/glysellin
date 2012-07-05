if File.exists? 'glysellin/engine/routes'
  require 'glysellin/gateway/base'
  require 'glysellin/gateway/paypal_integral'
  require 'glysellin/gateway/mercanet'
  require 'glysellin/gateway/sogenactif'
  require 'glysellin/gateway/check'
else
  require File.expand_path('../gateway/base', __FILE__)
  require File.expand_path('../gateway/paypal_integral', __FILE__)
  require File.expand_path('../gateway/mercanet', __FILE__)
  require File.expand_path('../gateway/sogenactif', __FILE__)
  require File.expand_path('../gateway/check', __FILE__)
end

module Glysellin  
  module Gateway
  end
end
