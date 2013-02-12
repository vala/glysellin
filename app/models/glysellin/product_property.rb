module Glysellin
  class ProductProperty < ActiveRecord::Base
    self.table_name = 'glysellin_product_properties'
    attr_accessible :adjustement, :name, :value, :variant, :variant_id, :type, :type_id

    belongs_to :variant, polymorphic: true, foreign_key: 'variant_id'
    belongs_to :type, class_name: 'Glysellin::ProductPropertyType', foreign_key: 'type_id'

    validate :check_uniqueness_of_type

    validates_presence_of :type, :value

    private

    def check_uniqueness_of_type
      if self.variant.properties.map(&:type).include? self.type
        errors.add(:type, "existe déjà")
      end
    end
  end
end