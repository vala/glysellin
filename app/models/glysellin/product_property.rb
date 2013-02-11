module Glysellin
  class ProductProperty < ActiveRecord::Base
    self.table_name = 'glysellin_product_properties'
    attr_accessible :adjustement, :name, :value, :variant, :variant_id, :type, :type_id

    belongs_to :variant, polymorphic: true, foreign_key: 'variant_id'
    belongs_to :type, class_name: 'Glysellin::ProductPropertyType', foreign_key: 'type_id'
  end
end