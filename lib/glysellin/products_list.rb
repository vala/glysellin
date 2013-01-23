module Glysellin
  module ProductsList
    extend ActiveSupport::Concern

    def quantified_items
      raise "You should implement `#quantified_items` in any class including Glysellin::ProductsList"
    end

    def each_items &block
      quantified_items.each do |item, quantity|
        yield item, quantity
      end
    end

    # Gets order subtotal from items only
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated subtotal
    def subtotal
      @_subtotal ||= quantified_items.reduce(0) do |total, quantified_item|
        item, quantity = quantified_item
        total + (item.price * quantity)
      end
    end

    def eot_subtotal
      @_eot_subtotal ||= quantified_items.reduce(0) do |total, quantified_item|
        item, quantity = quantified_item
        total + (item.eot_price * quantity)
      end
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
  end
end
