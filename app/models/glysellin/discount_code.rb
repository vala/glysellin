module Glysellin
  class DiscountCode < ActiveRecord::Base
    self.table_name = 'glysellin_discount_codes'

    attr_accessible :code, :discount_type_id, :expires_on, :name, :value

    belongs_to :discount_type, inverse_of: :discount_codes
    has_many :order_adjustments, as: :adjustment

    validates_presence_of :discount_type

    before_save do
      self.code.downcase!
    end

    def to_adjustment order
      calculator = Glysellin.discount_type_calculators[discount_type.identifier].new(order, value)

      {
        name: name,
        value: -calculator.calculate,
        adjustment: self
      }
    end
  end
end
