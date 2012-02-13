module Glysellin
  class ProductImage < ActiveRecord::Base
    self.table_name = 'glysellin_product_images'
    belongs_to :product
    has_attached_file :image,
      :styles => {
        :thumb => '100x100#',
        :content => '300x300'
      }
  end
end
