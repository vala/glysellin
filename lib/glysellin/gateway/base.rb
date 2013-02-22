module Glysellin

  def self.gateways
    Hash[Gateway.gateways_list.map {|g| [g[:name], g[:gateway]]}]
  end

  module Gateway
    extend AbstractController::Rendering

    # List of available gateways in the app
    mattr_accessor :gateways_list
    @@gateways_list = []

    class Base
      def log message
        if self.class.debug
          Rails.logger.debug(
            "[Glysellin - #{ self.class.gateway_name }] :: #{ message }"
          )
        end
      end

      class << self
        attr_accessor :gateway_name

        def register name, gateway
          Gateway.gateways_list << {:name => name, :gateway => gateway}
          @gateway_name = name.split('_').map(&:capitalize).join(" ")
        end

        def config
          yield self
        end
      end
    end
  end
end