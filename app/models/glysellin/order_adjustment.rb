module Glysellin
  class OrderAdjustment < ActiveRecord::Base
    self.table_name = 'glysellin_order_adjustments'

    attr_accessible :adjustment_id, :adjustment_type, :name, :order_id, :value,
      :adjustment, :order

    belongs_to :order
    belongs_to :adjustment, polymorphic: true

    def type
      adjustment_type.demodulize.underscore.dasherize
    end

    def valid
      true
    end
  end
end
