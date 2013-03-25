require "state_machine"

module Glysellin
  module Cart
    class Basket
      include ProductsList
      include Cart::NestedResource
      include Cart::Select
      include ActiveModel::Model
      include ActiveModel::Dirty
      include ActiveModel::Observing

      attr_accessor :total, :products, :adjustments, :state, :order_id
      attr_reader :use_another_address_for_shipping

      # Relations
      #
      nested_resource :customer
      nested_resource :billing_address, class_name: "Address"
      nested_resource :shipping_address, class_name: "Address"
      select :payment_method, class_name: "Glysellin::PaymentMethod"
      select :shipping_method, class_name: "Glysellin::ShippingMethod"

      # Checkout state management
      #
      define_attribute_methods [:state]

      state_machine initial: :init do
        event :products_added do
          transition all => :filled
        end

        # When cart content is validated, including products list
        # and coupon codes
        #
        event :validated do
          transition all => :addresses
        end

        # When addresses are filled and validated
        #
        event :addresses_filled do
          transition all => :choose_shipping_method
        end

        # When shipping method is chosen
        #
        event :shipping_method_chosen do
          transition all => :choose_payment_method
        end

        # When payment method is chosen
        #
        event :payment_method_chosen do
          transition all => :ready
        end

        # State validations
        state :products_added, :addresses, :choose_shipping_method, :choose_payment_method, :ready do
          validates_presence_of :products
        end

        state :addresses, :choose_shipping_method, :choose_payment_method, :ready do
          validate do
            validate_customer_informations
          end
        end

        state :choose_shipping_method, :choose_payment_method, :ready do
          validates_presence_of :shipping_method_id
          validate do
            validate_shippable
          end
        end

        state :choose_payment_method, :ready do
          validates_presence_of :payment_method_id
        end

        after_transition any => :ready, do: :generate_order
      end

      def initialize str = nil, options = {}
        data = parse_session(str, options)
        super(data)
      end

      def parse_session str, options
        data = str.presence ?
          ActiveSupport::JSON.decode(str).with_indifferent_access :
          { adjustments: [], products: [] }

        data.reverse_merge(options)
      end

      #############################################
      #
      #         Cart content management
      #
      #############################################

      # Used to implement ProductsList interface #each method
      def quantified_items
        products.map { |product| [product.variant, product.quantity] }
      end

      def empty?
        products.length == 0
      end

      def products_total
        products.reduce(0) { |total, product| total + product.quantity }
      end

      def product product_id
        products.find { |product| product.variant.id == product_id.to_i }
      end

      # Mass products assignement, from session hash
      def products=(items)
        if items.is_a? Array
          @products = items.map do |product|
            Product.new(product)
          end
        end
      end

      # Mass adjustments assignement, from session hash
      def adjustments=(items)
        if items.is_a? Array
          @adjustments = items.map do |adjustment|
            Adjustment.build(self, adjustment)
          end.compact
        end
      end

      def adjustments
        @adjustments ||= []
      end

      #############################################
      #
      #          Quantities management
      #
      #############################################

      # Product scoped quantity update
      #
      def set_quantity product_id, quantity, options = {}
        options.reverse_merge!(override: false)
        quantity = quantity.to_i

        return unless quantity > 0

        # If product was in cart
        if (product = self.product(product_id))
          if options[:override]
            product.quantity = quantity
          else
            product.quantity += quantity
          end
        else
          @products << Glysellin::Cart::Product.new(
            id: product_id,
            quantity: quantity
          )
        end

        # Refresh discount code adjustment
        self.discount_code = discount_code
      end

      # Remove product from cart, given its id
      #
      def remove product_id
        products.reject! { |product| product.variant.id == product_id.to_i }
      end

      # General check to see if cart is valid
      #
      def update_quantities
        @products = products.reduce([]) do |products, product|
          # If product is not published
          if !product.variant.published
            set_error(:item_not_for_sale, item: product.variant.name)
          # If product is not in stock
          elsif !product.variant.in_stock?
            set_error(:item_out_of_stock, item: product.variant.name)
          # If product's available stock is less than required quantity
          elsif !product.variant.available_for(product.quantity)
            set_error(
              :not_enough_stock_for_item,
              item: product.variant.name, stock: product.variant.in_stock
            )
            product.quantity = product.variant.in_stock
            products << product if product.quantity > 0
          # Else, keep product as is in cart
          else product.variant.unlimited_stock || product.variant.in_stock >= product.quantity
            products << product
          end

          products
        end

        # TODO: Doesn't work, think in something else ...
        if discount_code == false
          set_error(:invalid_discount_code)
        end
      end


      #############################################
      #
      #           Quantity management
      #
      #############################################

      def add(params)
        set_quantity(params[:product_id], params[:quantity])
      end

      def update(attributes = {})
        filtered_attributes(attributes).each do |attr, value|
          public_send(:"#{ attr }=", value)
        end if attributes
      end

      # Filters forbidden attributes
      #
      def filtered_attributes attributes
        forbidden = [:id, :created_at, :updated_at]

        # Filter aux function to browse hash tree and reject key by key
        # forbidden attributes
        #
        filter = lambda { |hash, field|
          key, value = field

          if value.is_a? Hash
            hash[key] = value.reduce({}, &filter)
          else
            hash[key] = value unless forbidden.include?(key)
          end

          hash
        }

        attributes.with_indifferent_access.reduce({}, &filter)
      end

      #############################################
      #
      #        Discount code handling
      #
      #############################################

      def discount_code=(val)
        # Destroy old discount code
        adjustments.delete(discount)

        discount = Glysellin::Cart::Adjustment::DiscountCode.from_code(val, self)
        adjustments << discount if discount

        discount
      end

      def discount_code
        (adjustment = discount) ? adjustment.discount_code : nil
      end

      def discount
        adjustments.find { |a| a.type == "discount-code" }
      end

      #############################################
      #
      #                Address
      #
      #############################################

      # Allows setting use_another_address_for_shipping attribute, ensuring
      # it is stored as a Boolean value and not a number string
      #
      def use_another_address_for_shipping=(val)
        value = val.is_a?(String) ? (val.to_i > 0) : val
        @use_another_address_for_shipping = value
      end

      # Set the shipping method id on the cart by creating the corresponding
      # adjustment at the same time to ensure cart price and recap takes
      # shipping costs into account
      #
      def shipping_method_id=(val)
        @shipping_method_id = val

        if shipping_method_id
          adjustments.reject! { |a| a.type == "shipping-method" }
          adjustment = Glysellin::Cart::Adjustment::ShippingMethod.new(self,
            shipping_method_id: shipping_method_id
          )

          adjustments << adjustment
        end

        @shipping_method_id
      end

      # Shortcut method to get shipping adjustments from adjustments list
      #
      def shipping
        adjustments.find { |a| a.type == "shipping-method" }
      end

      # Validates customer informations are correctly filled
      #
      def validate_customer_informations
        validate_nested_resource(:customer)
        validate_nested_resource(:billing_address)

        if use_another_address_for_shipping
          validate_nested_resource(:shipping_address)
        end
      end

      # Validates the selected country is eligible for the current cart contents
      # to be shipped to
      #
      def validate_shippable
        if !shipping || !shipping.valid
          code = use_another_address_for_shipping ?
            shipping_address.country : billing_address.country
          country = Glysellin::Helpers::Countries::COUNTRIES_LIST[code]

          errors.add(
            :shipping_method_id,
            I18n.t(
              "glysellin.errors.cart.shipping_method_unavailable_for_country",
              method: shipping_method.name,
              country: country
            )
          )
        end
      end

      #############################################
      #
      #             Order management
      #
      #############################################

      # Generates an order from the current cart state and stores its id in
      # the cart to be fetched back later
      #
      def generate_order
        clean_order!

        attrs = attributes(:json).reject do |key, _|
          [:adjustments, :state, :order_id, :shipping_method_id].include?(key)
        end

        %w(billing shipping).each do |addr|
          attrs[:"#{ addr }_address_attributes"] =
            attrs.delete(:"#{ addr }_address")
        end

        unless use_another_address_for_shipping
          attrs[:shipping_address_attributes] =
            attrs[:billing_address_attributes]
        end

        # Append shipping method id after addresses so the latters are present
        # when shipping adjustment is processed on order
        attrs[:shipping_method_id] = shipping_method_id

        attrs[:discount_code] = discount_code

        self.order = Glysellin::Order.create!(attrs)
      end

      # Retrieve order from database if it exists, or use cached version
      #
      def order
        @order ||= Glysellin::Order.where(id: order_id).first
      end

      # Assign order and order_id, if nil is explicitly passed, ensure we
      # set order id to nil too
      #
      def order=(order)
        self.order_id = order && order.id
        @order = order
      end

      # Cleans cart stored order if it exists
      #
      def clean_order!
        if order
          # Destroy current cart order if not paid already, cause
          # we're creating a new one
          order.destroy if order.state_name == :ready
          # unset order
          self.order = nil
        end
      end

      #############################################
      #
      #               Serialization
      #
      #############################################

      def attribute_names
        [
          :order_id, :products, :customer, :billing_address, :shipping_address,
          :use_another_address_for_shipping, :shipping_method_id,
          :payment_method_id, :adjustments, :state
        ]
      end

      def attributes(type = :ruby)
        attribute_names.reduce({}) do |hash, attr|
          value = send(attr)
          hash[attr] = (type == :json) ? value.as_json : value
          hash
        end
      end

      def serialize
        attributes(:json).to_json
      end

      def to_order
        Glysellin::Order.new
      end

      #############################################
      #
      #                 Errors
      #
      #############################################

      def set_error(key, options = {})
        errors.add(key, I18n.t("glysellin.errors.cart.#{ key }", options))
      end

      def validate_nested_resource key
        model = send(key)
        if !model.valid? && model.errors.any?
          model.errors.messages.each do |field, messages|
            messages.each do |error|
              errors.add(:"#{ key }.#{ field }", error)
            end
          end
        end
      end

      #############################################
      #
      #                 States
      #
      #############################################

      def available_states
        %w(filled addresses choose_shipping_method choose_payment_method ready)
      end

      def state_index
        available_states.index(state) || -1
      end

      def has_shipping_address?
        use_another_address_for_shipping
      end
    end
  end
end