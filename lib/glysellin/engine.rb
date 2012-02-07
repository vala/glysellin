module Glysellin
  class Engine < ::Rails::Engine
    isolate_namespace Glysellin
    
    initializer "glysellin.root_config" do |app|
      Glysellin.config do |config|
        config.app_root = app.root
      end
    end
  end
end
