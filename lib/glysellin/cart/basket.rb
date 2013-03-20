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

      attr_accessor :total, :products, :adjustments, :errors,
        :use_another_address_for_shipping, :state

      # Relations
      #
      nested_resource :customer
      nested_resource :billing_address, class_name: "Address"
      nested_resource :shipping_address, class_name: "Address"
      select :payment_method
      select :shipping_method

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
          # validates_associated :customer, :billing_address, :shipping_address
        end

        state :choose_shipping_method, :choose_payment_method, :ready do
          validates_presence_of :shipping_method_id
        end

        state :ready do
          validates_presence_of :payment_method_id
        end
      end

      def initialize str = nil, options = {}
        data = parse_session(str, options)
        super(data)
        @errors = ActiveModel::Errors.new(self)
        process_total!
      end

      def parse_session str, options
        data = str.presence ?
          ActiveSupport::JSON.decode(str).with_indifferent_access :
          { adjustments: [], products: [], errors: [] }

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
      end

      # Remove product from cart, given its id
      #
      def remove product_id
        products.reject! { |product| product.variant.id == product_id.to_i }
      end

      # General check to see if cart is valid
      #
      def update_quantities
        self.errors = ActiveModel::Errors.new(self)

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

        process_total!
      end


      #############################################
      #
      #           Quantity management
      #
      #############################################

      def add(params)
        set_quantity(params[:product_id], params[:quantity])
      end

      def update(attributes)
        attributes.each do |attr, value|
          public_send(:"#{ attr }=", value)
        end
      end

      #############################################
      #
      #        Discount code handling
      #
      #############################################

      def discount_code=(val)
        # Destroy old discount code
        @adjustments.delete(discount)

        discount = Glysellin::Cart::Adjustment::DiscountCode.from_code(val, self)
        @adjustments << discount if discount

        discount
      end

      def discount_code
        (adjustment = discount) ? adjustment.discount_code : nil
      end

      def discount
        @adjustments.find { |a| a.type == "discount-code" }
      end

      #############################################
      #
      #               Serialization
      #
      #############################################

      def attribute_names
        [
          :products, :adjustments, :customer, :billing_address,
          :use_another_address_for_shipping, :shipping_address,
          :shipping_method_id, :payment_method_id, :state
        ]
      end

      def attributes(options = {})
        attribute_names.reduce({}) do |hash, attr|
          value = send(attr)
          hash[attr] = options[:json] ? value.as_json : value
          hash
        end
      end


      def serialize
        attributes(json: true).to_json
      end

      def to_order
        Glysellin::Order.new()
      end

      #############################################
      #
      #                 Errors
      #
      #############################################

      def set_error(key, options = {})
        errors << I18n.t("glysellin.errors.cart.#{ key }", options)
      end

      #############################################
      #
      #                 States
      #
      #############################################

      def available_states
        %w(filled addresses choose_shipping_method choose_payment_method ready)
      end

      def has_shipping_address?
        false
      end

      protected

      def process_total!
        self.total = self.products.sum { |product| product.quantity * product.variant.price }
      end
    end
  end
end