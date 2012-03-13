module Glysellin
  class Order < ActiveRecord::Base
    self.table_name = 'glysellin_orders'
    has_many :items, :class_name => 'Glysellin::OrderItem', :foreign_key => 'order_id'
    belongs_to :customer
    belongs_to :billing_address, :foreign_key => 'billing_address_id', :class_name => 'Glysellin::Address'
    belongs_to :shipping_address, :foreign_key => 'shipping_address_id', :class_name => 'Glysellin::Address'
    has_many :payments
    
    accepts_nested_attributes_for :billing_address
    accepts_nested_attributes_for :shipping_address
    
    # Constants
    ORDER_STEP_CART = 'cart'
    ORDER_STEP_ADDRESS = 'fill_addresses'
    ORDER_STEP_PAYMENT_METHOD = 'recap'
    ORDER_STEP_PAYMENT = 'payment'
    
    # Ensure there is always an order reference for billing purposes
    after_save do
      unless self.ref
        self.ref = self.generate_ref 
        self.save
      end
    end
    
    # yield ref when to_param called on instance
    def to_param
      ref
    end
    
    # Automatic ref generation for our 
    def generate_ref
      unless ref
        if Glysellin.order_reference_generator
          Glysellin.order_reference_generator.call(self)
        else
          "#{Time.now.strftime('%Y%m%d%H%M')}-#{id}"
        end
      end
    end
    
    def initialize_from_json json
      self.attributes = ActiveSupport::JSON.decode(json)
    end
    
    def self.from_sub_forms order_hash, customer = nil
      o = Order.new
      # Define shipping address
      o.shipping_address = Address.new order_hash[:shipping_address] if order_hash.key?(:shipping_address)
      # Define billing address
      if order_hash.key?(:billing_address)
        same_address = order_hash[:billing_address].key?(:use_billing_address_for_shipping) ? !order_hash[:billing_address].delete(:use_billing_address_for_shipping).blank? : false
        o.billing_address = Address.new order_hash[:billing_address]
        # Define shipping address if we must use same address
        o.shipping_address = Address.new order_hash[:billing_address] if same_address
      end
      # Define payment method
      if order_hash.key?(:payment_method) && order_hash[:payment_method].key?(:type)
        payment = o.payments.build :status => PAYMENT_STATUS_PENDING
        payment.type = PaymentMethod.find_by_slug(order_hash[:payment_method][:type])
      end
      # Define products :
      if order_hash.key?(:products) && order_hash[:products].length > 0
        order_hash[:products].each do |product_slug, value|
          if product_slug && value != '0'
            item = OrderItem.create_from_product_slug(product_slug)
            o.items << item if item
          end
        end
      end
      if order_hash.key?(:product_choice) && order_hash[:product_choice].length > 0
        order_hash[:product_choice].each_value do |product_slug|
          if product_slug
            item = OrderItem.create_from_product_slug(product_slug)
            o.items << item if item
          end
        end
      end
      o
    end
    
    # Defines next resource to ask user for, given the state of the current order
    def next_step
      if items.length == 0
        ORDER_STEP_CART
      elsif !billing_address
        ORDER_STEP_ADDRESS
      elsif !(payments.length > 0)
        ORDER_STEP_PAYMENT_METHOD
      elsif payments.last.status == PAYMENT_STATUS_PENDING
        ORDER_STEP_PAYMENT
      end
    end
    
    def self.from_ref ref
      where(:ref => ref).first
    end    
    
    # Global order prices
    def subtotal df = false
      @_subtotal ||= items.reduce(0) {|l, r| l + (df ? r.df_price : r.price)}
    end
    
    def shipping_price df = false
      0
    end
    
    def total_price df = false
      @_total_price ||= (subtotal(df) + shipping_price(df))
    end
    
    # Get email
    def email
      billing_address.email
    end
    
    ########################################
    #
    #               Payment 
    #
    ########################################
    
    def payment
      payments.last
    end
    
    # Last payment method
    def payment_method
      payment.type rescue nil
    end
    
    def pay!
      payment.status = PAYMENT_STATUS_PAID
      payment.last_payment_action_on Time.now
      payment.save
    end
    
    def paid?
      !!payment.status == PAYMENT_STATUS_PAID
    end    
  end
end
