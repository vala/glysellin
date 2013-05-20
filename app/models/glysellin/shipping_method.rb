module Glysellin
  class ShippingMethod < ActiveRecord::Base
    self.table_name = "glysellin_shipping_methods"

    attr_accessible :identifier, :name

    has_many :orders, inverse_of: :shipping_method
    has_many :order_adjustments, as: :adjustment

    scope :ordered, order("name ASC")

    def to_adjustment order
      calculator = Glysellin.shipping_carriers[identifier].new(order)

      {
        name: name,
        value: calculator.calculate,
        adjustment: self
      }
    end
  end
end
