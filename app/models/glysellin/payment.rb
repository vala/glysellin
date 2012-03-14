module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'
    belongs_to :order
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id'
    
    def new_status s
      self.status = s
      self.last_payment_action_on = Time.now
      self.save
    end
  end
end
