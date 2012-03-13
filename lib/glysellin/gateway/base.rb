module Glysellin
  
  def self.gateways
    Hash[Gateway.gateways_list.map {|g| [g[:name], g[:gateway]]}]
  end
  
  module Gateway
    # List of available gateways in the app
    mattr_accessor :gateways_list
    @@gateways_list = []

    class Base      
      class << self
        def register name, gateway
          Gateway.gateways_list << {:name => name, :gateway => gateway}
        end
      end
    end
  end
end