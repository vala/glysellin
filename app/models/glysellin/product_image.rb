module Glysellin
  class ProductImage < ActiveRecord::Base
    belongs_to :product
    has_attached_file :image,
      :styles => {
        :thumb => '100x100#',
        :content => '300x300'
      }
  end
end
