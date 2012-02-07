module Glysellin
  class Payment < ActiveRecord::Base
    belongs_to :order
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id'
    
    def the_price
      df_price + ((integer_df_price * (integer_vat_rate / 100.0)) / (100*100))
    end
    
    def df_price
      integer_df_price / 100.0
    end
    
    def vat_rate
      integer_vat_rate / 100.0
    end
  end
end
