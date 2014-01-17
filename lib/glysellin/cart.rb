# Cart class inspired from Piggybak's gem before we write our own one
# Piggyback : http://github.com/piggybak/piggybak
#
require 'ostruct'

module Glysellin
  class Cart
    include ProductsList

    attr_writer :products
    attr_accessor :total, :errors

    METADATA = %w(discount_code adjustment)
    attr_accessor :discount_code, :adjustment

    def initialize(cookie='')
      parse!(cookie)
      process_total!
    end

    #############################################
    #
    #        Accessors with defaults
    #
    #############################################

    # Accessors that we initialize as empty arrays
    def products() @products ||= [] end
    alias :items :products

    def errors() @errors ||= [] end

    def discount_code=(val)
      refresh_discount_code!(val)
    end

    def refresh_discount_code!(val = nil)
      val ||= @discount_code

      if val && (code = DiscountCode.from_code(val)) && code.applicable_for?(subtotal)
        @discount_code = val
        set_adjustment_from_code(code)
      else
        @discount_code = nil
        @adjustment = nil
      end

      @discount_code
    end

    def set_adjustment_from_code code
      adjustment = code.to_adjustment(self)
      @adjustment = { "name" => adjustment[:name], "value" => adjustment[:value] }
    end

    def adjustments
      [OpenStruct.new(@adjustment)]
    end

    def adjustment_name() @adjustment["name"] rescue "" end
    def adjustment_value() @adjustment["value"] rescue 0 end

    #############################################
    #
    #         Cart content management
    #
    #############################################

    # Used to implement ProductsList interface #each method
    def quantified_items
      products.map { |product| [product[:product], product[:quantity]] }
    end

    def empty?
      products.length == 0
    end

    def empty!
      self.products = []
      METADATA.each { |key| self.send("#{ key }=", nil) }
    end

    def products_total
      products.reduce(0) { |total, product| total + product[:quantity] }
    end

    def product product_id
      products.find { |p| p[:product].id == product_id.to_i }
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
          product[:quantity] = quantity
        else
          product[:quantity] += quantity
        end
      else
        products << {
          product: Glysellin::Variant.find(product_id),
          quantity: quantity
        }
      end
    end

    # Remove product from cart, given its id
    #
    def remove product_id
      products.reject! { |p| p[:product].id == product_id.to_i }
    end

    # General check to see if cart is valid
    #
    def update_quantities
      self.errors = []

      self.products = self.products.reduce([]) do |products, item|
        case
        # If item is not published
        when !item[:product].published
          set_error(:item_not_for_sale, item: item[:product].name)
        # If item is not in stock
        when !item[:product].in_stock?
          set_error(:item_out_of_stock, item: item[:product].name)
        # If item's available stock is less than required quantity
        when !item[:product].available_for(item[:quantity])
          set_error(
            :not_enough_stock_for_item,
            item: item[:product].name, stock: item[:product].in_stock
          )
          item[:quantity] = item[:product].in_stock
          products << item if item[:quantity] > 0
        # Else, keep product as is in cart
        else item[:product].unlimited_stock || item[:product].in_stock >= item[:quantity]
          products << item
        end
        products
      end

      if discount_code == false
        set_error(:invalid_discount_code)
        self.discount_code = nil
      end

      process_total!
    end

    #############################################
    #
    #       Parsing cookie from string
    #
    #############################################

    def parse! cookie

      return unless cookie.presence

      headers, products = cookie.split('::')

      parse_products!(products || '')
      parse_metadata!(headers || '')

      refresh_discount_code!
      process_total!
    end

    def parse_metadata! headers
      headers.split(';').each do |item|
        key, value = item.split(':')
        if METADATA.include?(key)
          if value.match(/\^/)
            val = value.split(/\^\^/).map { |str| str.split(/\^/) }
            val = Hash[val]
          else
            val = value
          end
          send("#{ key }=", val)
        end
      end
    end

    def parse_products! products
      products.split(';').each do |item|
        id, quantity = item.split(':').map(&:to_i)
        item_product = Glysellin::Variant.find(id)
        self.products << { :product => item_product, :quantity => quantity }
      end
    end

    #############################################
    #
    #               Serialization
    #
    #############################################

    def serialize
      # Serialize headers
      headers = METADATA.reduce([]) do |headers, key|
        value = send(key)
        if value.presence
          if value.is_a? Hash
            serialized_value = value.map do |key, value|
              "#{ key }^#{ value }"
            end.join("^^")
            headers << "#{ key }:#{ serialized_value }"
          else
            headers << "#{ key }:#{ value }"
          end
        end
        headers
      end

      # Serialize products
      products = self.products.reduce([]) do |products, item|
        if item[:quantity].to_i > 0
          products << "#{ item[:product].id.to_s }:#{ item[:quantity].to_s }"
        end
        products
      end

      # Join headers and products
      headers.join(';') + "::" + products.join(';')
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
    #           Quantity management
    #
    #############################################

    def add(params)
      set_quantity(params[:product_id], params[:quantity])
    end

    def update(params)
      # Update each product in cart
      products.each do |p|
        id = p[:product].id
        set_quantity(id, params[:quantity][id.to_s], override: true)
      end

      if (code = params[:discount_code].presence)
        self.discount_code = code
      end

      update_quantities
    end

    protected

    def process_total!
      self.total = self.products.sum { |item| item[:quantity]*item[:product].price }
    end
  end
end