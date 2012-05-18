module Glysellin
  class BundleProduct < ActiveRecord::Base
    self.table_name = "glysellin_bundle_products"

    attr_accessible :bundle_id, :product_id, :quantity
    # Middle man association
    belongs_to :bundle
    belongs_to :product
  end
end
