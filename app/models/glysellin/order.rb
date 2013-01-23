require 'state_machine'

module Glysellin
  class Order < ActiveRecord::Base
    include ProductsList

    self.table_name = 'glysellin_orders'

    state_machine initial: :created do

      event :cart_filled do
        transition created: :cart
      end

      event :address_filled do
        transition cart: :address
      end

      event :payment_method_chosen do
        transition address: :payment
      end

      event :paid do
        transition payment: :paid
      end

      after_transition on: :paid, do: :set_payment
    end

    # Relations
    #
    # Order items are used to map order to cloned and simplified products
    #   so the Order propererties can't be affected by product updates
    has_many :items, :class_name => 'Glysellin::OrderItem', :foreign_key => 'order_id'
    # The actual buyer
    belongs_to :customer, :class_name => "::#{ Glysellin.user_class_name }", :inverse_of => :orders, :autosave => true
    # Addresses
    belongs_to :billing_address, :foreign_key => 'billing_address_id', :class_name => 'Glysellin::Address', :inverse_of => :billed_orders
    belongs_to :shipping_address, :foreign_key => 'shipping_address_id', :class_name => 'Glysellin::Address', :inverse_of => :shipped_orders
    # Payment tries
    has_many :payments, :inverse_of => :order

    # We want to be able to see fields_for addresses
    accepts_nested_attributes_for :billing_address
    accepts_nested_attributes_for :shipping_address
    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :customer
    accepts_nested_attributes_for :payments

    attr_accessible :billing_address_attributes, :shipping_address_attributes,
      :billing_address, :shipping_address, :payments,
      :items, :items_ids, :customer, :customer_id, :ref, :status, :paid_on,
      :user, :items, :payments, :customer_attributes, :payments_attributes,
      :items_attributes

    after_save :check_ref
    before_save :set_paid_if_paid_by_check

    # Ensure there is always an order reference for billing purposes
    def check_ref
      update_attribute(:ref, self.generate_ref) unless self.ref
    end

    # If admin sets payment date by hand and order was paid by check, fire :paid event
    def set_paid_if_paid_by_check
      paid! if (paid_on_changed? and payment? and paid_by_check?)
    end

    def paid_by_check?
      payment and payment.by_check?
    end

    # Callback invoked after event :paid
    def set_payment
        self.payment.new_status Payment::PAYMENT_STATUS_PAID
        update_attribute(:paid_on, payment.last_payment_action_on)
    end


    def use_billing_address_for_shipping; nil; end

    def init_addresses!
      self.build_billing_address unless billing_address
      self.build_shipping_address unless shipping_address
    end

    def init_payment!
      self.payments.build unless payment
    end

    # Define model to use it's ref when asked for parameterized
    #   representation of itself
    #
    # @return [String] the order ref
    def to_param
      ref
    end

    # Automatic ref generation for an order that can be overriden
    #   within the config initializer, and only executes if there's no
    #   existing ref inside for this order
    #
    # @return [String] the generated or existing ref
    def generate_ref
      if ref
        ref
      else
        if Glysellin.order_reference_generator
          Glysellin.order_reference_generator.call(self)
        else
          "#{Time.now.strftime('%Y%m%d%H%M')}-#{id}"
        end
      end
    end

    # Used to parse an Order item serialized into JSON
    #
    # @param [String] json JSON string object representing the order attributes
    #
    # @return [Boolean] wether or not the object has been
    #   successfully initialized
    def initialize_from_json! json
      self.attributes = ActiveSupport::JSON.decode(json)
    end

    # Gives the next step to ask user to pass through
    #   given the state of the current order deined by the informations
    #   already filled in the model
    def next_step
      Glysellin.step_routes[state_name]
    end

    # Customer's e-mail directly accessible from the order
    #
    # @return [String] the wanted e-mail string
    def email
      customer.email
    end

    ########################################
    #
    #               Payment
    #
    ########################################

    # Gives the last payment found for that order
    #
    # @return [Payment, nil] the found Payment item or nil
    def payment
      payments.last
    end

    # Returns the last payment method used if there has already been
    #   a payment try
    #
    # @return [PaymentType, nil] the PaymentMethod or nil
    def payment_method
      payment.type rescue nil
    end

    # Permits to create or update an order from nested forms (hashes)
    #   and can create a whole order object ready to be paid but
    #   only modifies the order from the params passed in the data param
    #
    # @param [Hash] data Hash of hashes containing order data from nested forms
    # @param [Customer] customer Customer object to map to the order
    #
    # @example Setting shipping address
    #   Glysellin::Order.from_sub_forms { shipping_address: { first_name: 'Me' ... } }
    #
    # @return [] the created or updated Order item
    def self.from_sub_forms data, ref = nil
      # Fetch order from ref or create a new one
      order = ref ? Order.find_by_ref(ref) : Order.new

      # errors = %w(addresses user payment_method products product_choices).reduce([]) do |errors, method|
      #   errors += (order.send("fill_#{ method }_from_hash", data) || [])
      # end

      # Try to fill as much as we can
      order.fill_addresses_from_hash(data)
      order.fill_user_from_hash(data)
      order.fill_payment_method_from_hash(data)
      order.fill_products_from_hash(data)
      order.fill_product_choices_from_hash(data)

      #
      order
    end

    def fill_addresses_from_hash data
      return unless (billing_params = data[:billing_address_attributes])

      # Store billing address
      self.build_billing_address(billing_params)

      # Check if we have to use the billing address for shipping
      same_address = data[:use_billing_address_for_shipping].presence

      # Define shipping address if we must use same address
      if same_address
        self.build_shipping_address(billing_params)
      # Else, if we are given a specific shipping address
      elsif data[:shipping_address_attributes]
        self.build_shipping_address(data[:shipping_address_attributes])
      end
      address_filled
    end

    def fill_user_from_hash data
      return unless data[:customer_attributes] && data[:customer_attributes].length > 0

      email = data[:customer_attributes][:email]

      if (user = Glysellin.user_class_name.constantize.find_by_email email)
        self.customer = user
      else
        user = self.build_customer(data[:customer_attributes])

        unless user.password && user.password_confirmation
          password = (rand*(10**20)).to_i.to_s(36)
          user.password = password
          user.password_confirmation = password
        end
      end
    end

    def fill_payment_method_from_hash data
      return unless data[:payments_attributes] && data[:payments_attributes].length > 0

      payment = self.payments.build :status => Payment::PAYMENT_STATUS_PENDING

      payment_hash = data[:payments_attributes].first.last
      payment.type = PaymentMethod.find(payment_hash[:type_id])
      payment_method_chosen
    end

    def fill_products_from_hash data
      return unless data[:items_attributes] && data[:items_attributes].length > 0

      # Process each desired item from cart
      data[:items_attributes].each do |item_hash_data|
        # Get data from [index, data] :items_attributes pair
        item_data = item_hash_data.last

        # Prepare needed product data
        product_id = item_data[:id]
        quantity = item_data[:quantity].to_i

        # If quantity is 0 we won't add it
        if product_id && quantity > 0
          # Try create item from given product_id and quantity
          items = OrderItem.create_from_product_id(product_id, quantity)
          # Add it to items if it has been created
          self.items += items
          cart_filled
        end
      end
    end

    def fill_product_choices_from_hash data
      return unless data[:product_choice] && data[:product_choice].length > 0

      data[:product_choice].each do |product_id|
        if product_id
          item = OrderItem.create_from_product_id(product_id, 1)
          self.items << item if item
        end
      end
    end
  end

end
