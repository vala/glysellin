module Glysellin
  class BundleProduct < ActiveRecord::Base
    self.table_name = "glysellin_bundle_products"

    attr_accessible :bundle_id, :product_id, :quantity, :bundle, :product
    # Middle man association
    belongs_to :bundle, class_name: 'Glysellin::Product', foreign_key: :bundle_id
    belongs_to :bundled_product, class_name: 'Glysellin::Product', foreign_key: :product_id

    # Don't validate presence of product to be able create first bundle_product before one of these
    # validates_presence_of :quantity
  end
end
