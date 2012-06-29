module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'
    
    belongs_to :order
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id'
    
    attr_accessible :status, :type_id, :type, :order, :order_id, :last_payment_action_on, :transaction_id
        
    def new_status s
      self.status = s
      self.last_payment_action_on = Time.now
      self.save
    end
    
    def new_transaction_id!
      last_transaction_with_id = self.class.where('transaction_id > 0').order('updated_at DESC').first
      next_id = last_transaction_with_id ? last_transaction_with_id.transaction_id + 1 : 1
      self.transaction_id = next_id
      self.save
    end
    
    def get_new_transaction_id
      self.new_transaction_id!
      self.transaction_id
    end
  end
end
