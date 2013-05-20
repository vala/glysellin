# encoding: utf-8

module Glysellin
  module Cart
    def self.new cookie = nil, options = {}
      Basket.new cookie, options
    end
  end
end

require 'glysellin/cart/model_wrapper'
require 'glysellin/cart/nested_resource'
require 'glysellin/cart/select'
require 'glysellin/cart/serializable'
require 'glysellin/cart/product'
require 'glysellin/cart/customer'
require 'glysellin/cart/address'
require 'glysellin/cart/payment_method'
require 'glysellin/cart/shipping_method'
require 'glysellin/cart/adjustment'
require 'glysellin/cart/basket'