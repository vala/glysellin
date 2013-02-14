module Glysellin
  class ProductProperty < ActiveRecord::Base
    self.table_name = 'glysellin_product_properties'
    attr_accessible :adjustement, :name, :value, :variant, :variant_id, :type, :type_id

    belongs_to :variant, polymorphic: true, foreign_key: 'variant_id'
    belongs_to :type, class_name: 'Glysellin::ProductPropertyType', foreign_key: 'type_id'

    # validate :check_uniqueness_of_type

    validates_presence_of :type, :value
    # validates_associated :type, :if => Proc.new { |type| !self.variant.properties.map(&:type).include?(type) }

    private

    def check_uniqueness_of_type
      if self.variant.properties.map(&:type).include? self.type
        errors.add(:type, I18n.t("glysellin.controllers.errors.double_property"))
      end
    end
  end
end