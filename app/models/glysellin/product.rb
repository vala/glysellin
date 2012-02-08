require 'digest/sha1'

module Glysellin
  class Product < ActiveRecord::Base    
    has_many :product_images
    has_and_belongs_to_many :taxonomies, :join_table => 'glysellin_products_taxonomies'
    validates_presence_of :name, :df_price, :vat_rate, :slug
    validates :sku, :presence => true, :if => Proc.new { Glysellin.autoset_sku }
    validates_numericality_of :df_price, :vat_rate
    
    before_validation do
      self.slug = self.name.to_slug
      self.sku = self.generate_sku unless (self.sku && self.sku.length > 0) || !Glysellin.autoset_sku
    end
        
    def generate_sku
      last_product = self.class.order('id DESC').limit(1)
      "Product-#{last_product.length > 0 ? (last_product.first.id + 1).to_s : '1'}"
    end
    
    def self.with_taxonomy taxonomy_slug
      taxonomy = Taxonomy.includes(:products).where(:slug => taxonomy_slug)
      taxonomy.length > 0 ? taxonomy.first.products : []
    end
  end
end
