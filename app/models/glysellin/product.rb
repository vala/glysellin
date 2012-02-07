require 'digest/sha1'

module Glysellin
  class Product < ActiveRecord::Base    
    has_many :product_images
    
    validates_presence_of :name, :integer_df_price, :integer_vat_rate, :slug
    validates :sku, :presence => true, :if => Proc.new { Glysellin.autoset_sku }
    validates_numericality_of :integer_df_price, :integer_vat_rate
    
    before_validation do
      self.integer_df_price = (self.integer_df_price * 100).to_i
      self.integer_vat_rate = (self.integer_vat_rate * 100).to_i
      self.slug = self.name.to_slug
      self.sku = self.generate_sku unless (self.sku && self.sku.length > 0) || !Glysellin.autoset_sku
    end
        
    def generate_sku
      last_product = self.class.order('id DESC').limit(1)
      "Product-#{last_product.length > 0 ? (last_product.first.id + 1).to_s : '1'}"
    end
  end
end
