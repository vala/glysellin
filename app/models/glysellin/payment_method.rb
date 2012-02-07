module Glysellin
  class PaymentMethod < ActiveRecord::Base
    has_many :payments, :foreign_key => 'type_id'
  end
end
