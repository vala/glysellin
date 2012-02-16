if File.exists? 'glysellin/engine/routes'
  require 'glysellin/gateway/base'
  require 'glysellin/gateway/paypal'
else
  require File.expand_path('../gateway/base', __FILE__)
  require File.expand_path('../gateway/paypal', __FILE__)
end

module Glysellin
  module Gateway
  end
end
