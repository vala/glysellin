module Glysellin
  class Order < ActiveRecord::Base
    self.table_name = 'glysellin_orders'

    # Relations
    #
    # Order items are used to map order to cloned and simplified products
    #   so the Order propererties can't be affected by product updates
    has_many :items, :class_name => 'Glysellin::OrderItem', :foreign_key => 'order_id'
    # The actual buyer
    belongs_to :customer, :class_name => "::#{ Glysellin.user_class_name }", :inverse_of => :orders
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

    # Status const to be used to define order status to payment
    ORDER_STATUS_PAYMENT_PENDING = 'payment'
    # Status const to be used to define order status to paid
    ORDER_STATUS_PAID = 'paid'
    # Status const to be used to define order status to shipping
    ORDER_STATUS_SHIPPING_PENDING = 'shipping'
    # Status const to be used to define order status to shipped
    ORDER_STATUS_SHIPPED = 'shipped'

    # Ensure there is always an order reference for billing purposes
    after_save do
      unless self.ref
        self.ref = self.generate_ref
        self.save
      end
    end

    def status_enum
      [ORDER_STATUS_PAYMENT_PENDING, ORDER_STATUS_PAID, ORDER_STATUS_SHIPPING_PENDING, ORDER_STATUS_SHIPPED].map do |s|
        [I18n.t("glysellin.labels.orders.statuses.#{ s }"), s]
      end
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
      completed_steps = {}
      completed_steps[ORDER_STEP_CART] = items.length > 0
      completed_steps[ORDER_STEP_ADDRESS] = billing_address
      completed_steps[ORDER_STEP_PAYMENT_METHOD] = payments.length > 0
      completed_steps[ORDER_STEP_PAYMENT] = payment && payment.status == Payment::PAYMENT_STATUS_PAID

      Glysellin.order_steps_process.each_with_index.reduce({ step: nil, continue: true }) do |acc, val|
        # Process step and store it if we haven't reached current step yet
        acc = { step: val.first, continue: completed_steps[val.first] } if acc[:continue]
        # If we're on the last step, only return the desired step
        (val.last == (Glysellin.order_steps_process.length - 1)) ? acc[:step] : acc
      end
    end

    # Gets order subtotal from items only
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated subtotal
    def subtotal
      @_subtotal ||= items.reduce(0) {|total, item| total + (item.price * item.quantity) }
    end

    def eot_subtotal
      @_eot_subtotal ||= items.reduce(0) {|total, item| total + (item.eot_price * item.quantity) }
    end

    # Not implemented yet
    def shipping_price
      0
    end

    def eot_shipping_price
      0
    end

    # Gets order total price from subtotal and adjustments
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated total price
    def total_price
      @_total_price ||= (subtotal + shipping_price)
    end

    def total_eot_price
      @_total_eot_price ||= (eot_subtotal + eot_shipping_price)
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

    # Tells the order it is paid and processes to the necessary
    #   updates the model and related object need to retrieve payment infos
    #
    # @return [Boolean] if the doc was saved
    def pay!
      self.payment.new_status Payment::PAYMENT_STATUS_PAID
      self.status = ORDER_STATUS_PAID
      self.paid_on = payment.last_payment_action_on
      self.save
    end

    # Tells if the order is currently paid or not
    #
    # @return [Boolean] whether it is paid or not
    def paid?
      payment.status == Payment::PAYMENT_STATUS_PAID
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

      # Try to fill as much as we can
      order.fill_addresses_from_hash(data)
      order.fill_payment_method_from_hash(data)
      order.fill_products_from_hash(data)
      order.fill_product_choices_from_hash(data)

      #
      order
    end

    def fill_addresses_from_hash data
      return unless data[:billing_address_attributes]
      # Store billing address
      self.build_billing_address(data[:billing_address_attributes])

      # Check if we have to use the billing address for shipping
      same_address = data[:use_billing_address_for_shipping].presence

      # Define shipping address if we must use same address
      if same_address
        self.build_shipping_address(data[:billing_address_attributes])
      # Else, if we are given a specific shipping address
      elsif data[:shipping_address_attributes]
        self.build_shipping_address(data[:shipping_address_attributes])
      end
    end

    def fill_payment_method_from_hash data
      return unless data[:payments_attributes] && data[:payments_attributes].length > 0

      payment = self.payments.build :status => Payment::PAYMENT_STATUS_PENDING

      payment_hash = data[:payments_attributes].first.last
      payment.type = PaymentMethod.find(payment_hash[:type_id])
      self.status = ORDER_STATUS_PAYMENT_PENDING
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
          item = OrderItem.create_from_product_id(product_id, quantity)
          # Add it to items if it has been created
          self.items << item if item
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
