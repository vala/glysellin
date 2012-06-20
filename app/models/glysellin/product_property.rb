module Glysellin
  class ProductProperty < ActiveRecord::Base
    self.table_name = 'glysellin_product_properties'
    attr_accessible :adjustement, :name, :value, :product, :product_id
    belongs_to :product
  end
end