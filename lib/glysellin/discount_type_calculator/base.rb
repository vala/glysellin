module Glysellin
  def self.discount_type_calculators
    Hash[
      DiscountTypeCalculator.discount_type_calculators_list.map do |dtc|
        [dtc[:name], dtc[:discount_type_calculator]]
      end
    ]
  end

  module DiscountTypeCalculator
    # List of available discount_type_calculators in the app
    mattr_accessor :discount_type_calculators_list
    @@discount_type_calculators_list = []

    class Base
      class << self
        def register name, discount_type_calculator
          DiscountTypeCalculator.discount_type_calculators_list << {
            :name => name,
            :discount_type_calculator => discount_type_calculator
          }
        end

        def config
          yield self
        end
      end
    end
  end
end
