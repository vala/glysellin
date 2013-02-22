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
      class << self
        attr_accessor :gateway_name

        mattr_accessor :activate_logger
        @@activate_logger = false

        def log message
          if @@activate_logger
            Rails.logger.info(
              "[Glysellin - #{ self.class.gateway_name }] :: #{ message }"
            )
          end
        end

        def register name, gateway
          Gateway.gateways_list << {:name => name, :gateway => gateway}
          @gateway_name = name.split('_').map(&:capitalize).join(" ")
        end

        def config
          yield self
        end
      end

      # Defer #log to ::log class method
      def log(msg) self.class.log(msg) end
    end
  end
end