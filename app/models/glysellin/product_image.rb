module Glysellin
  class ProductImage < ActiveRecord::Base
    self.table_name = 'glysellin_product_images'
    
    attr_accessible :image, :imageable_id, :imageable_type
    
    belongs_to :imageable, polymorphic: true
    
    has_attached_file :image,
      :styles => {
        :thumb => '100x100#',
        :content => '300x300'
      }
  end
end
