module Glysellin
  class BundleProduct < ActiveRecord::Base
    self.table_name = "glysellin_bundle_products"

    attr_accessible :bundle_id, :product_id, :quantity, :bundle, :product
    # Middle man association
    belongs_to :bundle
    belongs_to :product
    
    # Don't validate presence of product to be able create first bundle_product before one of these
    validates_presence_of :quantity
  end
end
