module Glysellin

  def self.shipping_carriers
    Hash[ShippingCarrier.shipping_carriers_list.map {|sc| [sc[:name], sc[:carrier]]}]
  end

  module ShippingCarrier
    extend AbstractController::Rendering

    # List of available gateways in the app
    mattr_accessor :shipping_carriers_list
    @@shipping_carriers_list = []

    class Base
      class << self
        def register name, carrier
          ShippingCarrier.shipping_carriers_list << {:name => name, :carrier => carrier}
        end

        def config
          yield self
        end
      end

      @@config_file = nil

      def initialize
        raise "Config file is not defined for #{ self.name } shipping method" unless @@config_file
        @config = YAML.load(File.read @@config_file)['config']
      end

      def rate order
        @config.each do |item|
          if item['countries'].split(',').include?(order.shipping_address.country)
            return process_rate(order, item['rates'])
          end
        end
        # Return nil if country not accepted
        nil
      end


      def process_rate order, rates

      end
    end
  end
end