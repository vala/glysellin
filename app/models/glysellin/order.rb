module Glysellin
  class Order < ActiveRecord::Base
    has_many :items, :class_name => 'OrderItem', :foreign_key => 'order_id'
    belongs_to :customer
    belongs_to :billing_address, :foreign_key => 'billing_address_id', :class_name => 'Glysellin::Address'
    belongs_to :shipping_address, :foreign_key => 'shipping_address_id', :class_name => 'Glysellin::Address'
    has_many :payments
    
    accepts_nested_attributes_for :billing_address
    accepts_nested_attributes_for :shipping_address
    
    after_save do
      self.ref = self.generate_ref unless self.ref
    end
    
    def generate_ref
      unless ref
        "#{Time.now.strftime('%Y%m%d%H%M')}-#{id}"
        save
      end
    end
    
    def initialize_from_json json
      self.attributes = ActiveSupport::JSON.decode(json)
    end
    
    def from_ref ref
      where(:ref => ref).first
    end    
  end
end
