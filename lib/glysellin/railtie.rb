module Glysellin
  class Railtie < Rails::Railtie
    initializer "glysellin config" do
      p 'Config instanciated'
    end
  end
end