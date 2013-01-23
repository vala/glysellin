module Glysellin
  module ProductsList
    extend ActiveSupport::Concern

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
  end
end
