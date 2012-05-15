class BundleProduct < ActiveRecord::Base
  self.table_name = "glysellin_bundle_product"

  attr_accessible :bundle_id, :product_id, :quantity
  # Middle man association
  belongs_to :bundle
  belongs_to :product
end
