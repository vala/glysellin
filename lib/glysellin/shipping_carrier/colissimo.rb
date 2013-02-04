module Glysellin
  module ShippingCarrier
    class Colissimo < Base
      register 'colissimo', self

      def initialize order
        @order = order
      end

      def calculate
        weight = @order.total_weight
        country = @order.shipping_address.country

        zone = prices.find do |zone|
          zone[:countries].include?(country)
        end

        if zone
          weight_price = zone[:prices].find do |max_weight, price|
            weight < max_weight
          end

          weight_price.last if weight_price
        end
      end

      def prices
        return @prices if @prices

        csv = CSV.parse File.read File.expand_path(
          File.join(
            *%w(.. .. .. .. db seeds shipping_carrier rates colissimo.csv)
          ),
          __FILE__
        )

        @prices = csv.shift[1..-1].map do |c|
          {
            countries: c.split(",").map(&:strip),
            prices: {}
          }
        end

        csv.each do |row|
          max_weight = row.shift.to_f
          row.each_with_index do |cell, index|
            @prices[index][:prices][max_weight] = cell.presence ? cell.to_f : cell
          end
        end

        @prices
      end

    end
  end
end