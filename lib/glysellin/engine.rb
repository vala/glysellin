require 'glysellin/helpers'
require 'glysellin/engine/routes'

module Glysellin
  class Engine < ::Rails::Engine

    initializer "Include Helpers" do |app|
      ActiveSupport.on_load :action_controller do
        Helpers.include!
      end
    end

  end
end
