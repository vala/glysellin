module Glysellin
  class Payment < ActiveRecord::Base
    belongs_to :order
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id'    
  end
end
