module Glysellin
  module ShippingCarrier
    class Colissimo < Base
      include Helpers::CountryWeightTable

      register 'colissimo', self

      country_weight_table_file 'colissimo.csv'

      def initialize order
        @order = order
      end

      def calculate
        price_for_weight_and_country
      end
    end
  end
end