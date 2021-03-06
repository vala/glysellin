require 'friendly_id'

module Glysellin
  class Variant < ActiveRecord::Base
    include ProductMethods
    extend FriendlyId

    friendly_id :name, use: :slugged

    self.table_name = 'glysellin_variants'

    attr_accessible :eot_price, :in_stock, :name, :position, :price,
      :published, :sku, :slug, :unlimited_stock, :product, :product_id,
      :properties_attributes, :properties, :weight, :unmarked_price

    belongs_to :product, class_name: 'Glysellin::Product',
      foreign_key: 'product_id'

    has_many :properties, class_name: 'Glysellin::ProductProperty',
      as: :variant, extend: Glysellin::PropertyFinder, dependent: :destroy

    accepts_nested_attributes_for :properties, allow_destroy: true

    validates_presence_of :name, if: proc { |v| v.product.variants.length > 1 }
    validates_numericality_of :price
    validates_numericality_of :in_stock, if: proc { |v| v.in_stock.presence }

    before_validation :check_prices

    after_initialize :prepare_properties

    AVAILABLE_QUERY = <<-SQL
      glysellin_variants.published = ? AND (
        glysellin_variants.unlimited_stock = ? OR
        glysellin_variants.in_stock > ?
      )
    SQL

    scope :available, where(AVAILABLE_QUERY, true, true, 0)

    def prepare_properties
      if product && product.product_type
        product.product_type.property_types.each do |type|
          properties.build(type: type) if properties.send(type.name) == false
        end
      end
    end

    def description
      product.description
    end

    def vat_rate
      product.vat_rate
    end

    def check_prices
      vat_ratio = self.product.vat_ratio rescue Glysellin.default_vat_rate
      # If we have to fill one of the prices when changed
      if eot_changed_alone?
        self.price = (self.eot_price * vat_ratio).round(2)
      elsif price_changed_alone?
        self.eot_price = (self.price / vat_ratio).round(2)
      end
    end

    def eot_changed_alone?
      eot_changed_alone = self.eot_price_changed? && !self.price_changed?
      new_record_eot_alone = self.new_record? && self.eot_price && !self.price

      eot_changed_alone || new_record_eot_alone
    end

    def price_changed_alone?
      self.price_changed? || (self.new_record? && self.price)
    end

    def in_stock?
      unlimited_stock || in_stock > 0
    end

    def available_for quantity
      unlimited_stock || in_stock >= quantity
    end

    def name fullname = true
      variant_name, product_name = super().presence, product.name

      if fullname
        variant_name ? "#{ product_name } - #{ variant_name }" : product_name
      else
        variant_name ? variant_name : product_name
      end
    end

    def marked_down?
      (p = unmarked_price.presence) && p != price
    end
  end
end