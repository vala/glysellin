module Glysellin
  class Variant < ActiveRecord::Base
    self.table_name = 'glysellin_variants'
    attr_accessible :eot_price, :in_stock, :name, :position, :price, :published, :sku, :slug, :unlimited_stock, :product, :product_id, :properties_attributes, :properties
    
    
    belongs_to :product, class_name: 'Glysellin::Product', foreign_key: 'product_id'
    has_many :properties, class_name: 'Glysellin::ProductProperty', as: :variant
    accepts_nested_attributes_for :properties
  end
end