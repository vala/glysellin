module Glysellin
  module ProductsList
    extend ActiveSupport::Concern

    def quantified_items
      raise "You should implement `#quantified_items` in any class including Glysellin::ProductsList"
    end

    def each_items &block
      if block_given?
        quantified_items.each &block
      else
        quantified_items.each
      end
    end

    # Gets order subtotal from items only
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated subtotal
    #
    def subtotal
      quantified_items.reduce(0) do |total, quantified_item|
        item, quantity = quantified_item
        total + (item.price * quantity)
      end
    end

    def eot_subtotal
      quantified_items.reduce(0) do |total, quantified_item|
        item, quantity = quantified_item
        total + (item.eot_price * quantity)
      end
    end

    def total_weight
      each_items.reduce(0) do |total, quantified_item|
        item, quantity = quantified_item
        weight = item.weight.presence || Glysellin.default_product_weight
        total + (quantity * weight)
      end
    end

    def adjustments
      respond_to?(:order_adjustments) ? order_adjustments : []
    end

    def adjustments_total
      adjustments.reduce(0) do |total, adj|
        total + adj.value.to_f
      end
    end

    def eot_adjustments_total
      adjustments_total * (eot_subtotal / subtotal)
    end

    # Gets order total price from subtotal and adjustments
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated total price
    def total_price
      (subtotal + adjustments_total).round(2)
    end

    def total_eot_price
      (eot_subtotal + eot_adjustments_total).round(2)
    end
  end
end
