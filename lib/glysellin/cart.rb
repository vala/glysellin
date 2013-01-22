# Cart class borrowed from Piggybak's gem before we write our own one
# Piggyback : http://github.com/piggybak/piggybak
#
module Glysellin
  class Cart
    attr_accessor :products
    attr_accessor :total
    attr_accessor :errors
    attr_accessor :extra_data
    alias :subtotal :total
    alias :items :products

    def initialize(cookie='')
      self.products = []
      self.errors = []
      cookie ||= ''
      cookie.split(';').each do |item|
        item_product = Glysellin::Product.find_by_id(item.split(':')[0])
        if item_product.present?
          self.products << { :product => item_product, :quantity => (item.split(':')[1]).to_i }
        end
      end
      process_total!

      self.extra_data = {}
    end

    def self.to_hash(cookie)
      cookie ||= ''
      cookie.split(';').inject({}) do |hash, item|
        hash[item.split(':')[0]] = (item.split(':')[1]).to_i
        hash
      end
    end

    def self.to_string(cart)
      cookie = ''
      cart.each do |k, v|
        cookie += "#{k.to_s}:#{v.to_s};" if v.to_i > 0
      end
      cookie
    end

    def self.add(cookie, params)
      cart = to_hash(cookie)
      cart["#{params[:product_id]}"] ||= 0
      cart["#{params[:product_id]}"] += params[:quantity].to_i
      to_string(cart)
    end

    def self.remove(cookie, product_id)
      cart = to_hash(cookie)
      cart[product_id] = 0
      to_string(cart)
    end

    def self.update(cookie, params)
      cart = to_hash(cookie)
      cart.each { |k, v| cart[k] = params[:quantity][k].to_i }
      to_string(cart)
    end

    def to_cookie
      cookie = ''
      self.products.each do |item|
        cookie += "#{item[:product].id.to_s}:#{item[:quantity].to_s};" if item[:quantity].to_i > 0
      end
      cookie
    end

    def update_quantities
      self.errors = []
      new_products = []
      self.products.each do |item|
        if !item[:product].active
          self.errors << ["Sorry, #{item[:product].description} is no longer for sale"]
        elsif item[:product].unlimited_inventory || item[:product].quantity >= item[:quantity]
          new_products << item
        elsif item[:product].in_stock == 0
          self.errors << ["Sorry, #{item[:product].description} is no longer available"]
        else
          self.errors << ["Sorry, only #{item[:product].quantity} available for #{item[:product].description}"]
          item[:quantity] = item[:product].quantity
          new_products << item if item[:quantity] > 0
        end
      end
      self.products = new_products

      process_total!
    end

    def set_extra_data(form_params)
      form_params.each do |k, v|
        self.extra_data[k.to_sym] = v if ![:controller, :action].include?(k)
      end
    end

    protected

    def process_total!
      self.total = self.products.sum { |item| item[:quantity]*item[:product].price }
    end
  end
end