module Glysellin
  class Variant < ActiveRecord::Base
    include ProductMethods
    self.table_name = 'glysellin_variants'
    attr_accessible :eot_price, :in_stock, :name, :position, :price, 
      :published, :sku, :slug, :unlimited_stock, :product, :product_id, 
        :properties_attributes, :properties, :weight
    
    belongs_to :product, class_name: 'Glysellin::Product', foreign_key: 'product_id'
    has_many :properties, class_name: 'Glysellin::ProductProperty', as: :variant
    accepts_nested_attributes_for :properties
    
    validates_numericality_of :eot_price, :price
    validates_numericality_of :in_stock, if: proc { |p| p.in_stock.presence }

    def description
      product.description 
    end

    def vat_rate
      product.vat_rate 
    end

    # TODO : make it work
    #
    # before_validation :check_prices
    
    # def check_prices
    #   vat_ratio = self.product.vat_ratio rescue Glysellin.default_vat_rate
    #   # If we have to fill one of the prices when changed
    #   if (self.eot_price_changed? && !self.price_changed?) ||
    #       (self.new_record? && self.eot_price && !self.price)
    #     self.price = self.eot_price * vat_ratio
    #   elsif self.price_changed? || (self.new_record? && self.price)
    #     self.eot_price = self.price / vat_ratio
    #   end
    # end
  end
end