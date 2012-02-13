module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'
    belongs_to :order
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id'    
  end
end
