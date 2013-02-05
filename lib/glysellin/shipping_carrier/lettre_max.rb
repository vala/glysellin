module Glysellin
  module ShippingCarrier
    class LettreMax < Glysellin::ShippingCarrier::Base
      include Helpers::CountryWeightTable

      register 'lettre-max', self

      country_weight_table_file 'lettre-max.csv'

      def initialize order
        @order = order
      end

      def calculate
        price_for_weight_and_country
      end
    end
  end
end
