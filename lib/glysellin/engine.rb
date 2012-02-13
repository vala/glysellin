if File.exists? 'glysellin/engine/routes'
  require 'glysellin/engine/routes'
else
  require File.expand_path('../engine/routes', __FILE__)
end

module Glysellin
  class Engine < ::Rails::Engine
    initializer "glysellin.root_config" do |app|
      Glysellin.config do |config|
        config.app_root = app.root
      end
    end
  end
end
