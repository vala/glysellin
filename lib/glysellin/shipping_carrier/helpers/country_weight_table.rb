module Glysellin
  module ShippingCarrier
    module Helpers
      module CountryWeightTable
        extend ActiveSupport::Concern

        module ClassMethods
          attr_accessor :path_to_data

          def country_weight_table_file path
            @path_to_data = File.expand_path(
              File.join(
                *%w(.. .. .. .. .. db seeds shipping_carrier rates).push(path)
              ),
              __FILE__
            )
          end
        end

        def price_for_weight_and_country
          weight = @order.total_weight
          country = @order.shipping_address.country

          zone = prices_data.find do |zone|
            zone[:countries].include?(country)
          end

          if zone
            weight_price = zone[:prices].find do |max_weight, price|
              weight < max_weight
            end

            weight_price.last if weight_price
          end
        end

        def prices_data
          return @prices if @prices

          csv = CSV.parse File.read self.class.path_to_data

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
end