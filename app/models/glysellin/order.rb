module Glysellin
  class Order < ActiveRecord::Base
    has_many :items, :class_name => 'OrderItem', :foreign_key => 'order_id'
    belongs_to :customer
    belongs_to :billing_address, :foreign_key => 'billing_address_id', :class_name => 'Glysellin::Address'
    belongs_to :shipping_address, :foreign_key => 'shipping_address_id', :class_name => 'Glysellin::Address'
    has_many :payments
    
    accepts_nested_attributes_for :billing_address
    accepts_nested_attributes_for :shipping_address
    
    # Ensure there is always an order reference for billing purposes
    after_save do
      self.ref = self.generate_ref unless self.ref
    end
    
    # Automatic ref generation for our 
    def generate_ref
      unless ref
        if Glysellin.order_reference_generator
          Glysellin.order_reference_generator.call(self)
        else
          "#{Time.now.strftime('%Y%m%d%H%M')}-#{id}"
        end
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
