class Glysellin::ProductType < ActiveRecord::Base
  self.table_name = 'glysellin_product_types'

  has_and_belongs_to_many :property_types,
    class_name: 'Glysellin::ProductPropertyType',
    join_table: 'glysellin_product_types_property_types'

  has_many :products

  attr_accessible :name, :product_ids, :property_type_ids
end
