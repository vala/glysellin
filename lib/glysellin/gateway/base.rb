module Glysellin
  module Gateway
    # List of available gateways in the app
    mattr_accessor :gateways_list
    @@gateways_list = []

    class Base      
      def self.register name, gateway
        Gateway.gateways_list << {:name => name, :gateway => gateway}
      end
    end
  end
end