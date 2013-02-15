module Glysellin
  class ProductPropertyType < ActiveRecord::Base
    self.table_name = 'glysellin_product_property_types'
    attr_accessible :eot_price, :in_stock, :name, :position, :price, :published, :sku, :slug, :unlimited_stock

    has_many :properties, class_name: "Glysellin::ProductProperty"

    has_and_belongs_to_many :product_types, class_name: 'Glysellin::ProductType',
      join_table: 'glysellin_product_types_property_types'
  end
end