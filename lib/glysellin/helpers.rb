require "glysellin/helpers/controller"
require "glysellin/helpers/countries"
require "glysellin/helpers/views"

module Glysellin
  module Helpers
    class << self
      def include!
        [Controller, Countries, Views].each do |mod|
          ActionController::Base.send(:include, mod)
        end
      end
    end
  end
end
