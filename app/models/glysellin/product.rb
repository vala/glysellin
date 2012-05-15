require 'digest/sha1'

module Glysellin
  # Public: Product model to 
  class Product < ActiveRecord::Base
    include ModelInstanceHelperMethods
    include ProductMethods

    self.table_name = 'glysellin_products'
    
    # Relations
    #
    # The ProductImage model is used for products and bundles with the same
    has_many :images, through: :imageable, class_name: 'ProductImage'
    # Can have multiple taxonomies
    has_and_belongs_to_many :taxonomies, join_table: 'glysellin_products_taxonomies'
    # N..N relation between bundles and products
    has_many :bundle_products
    has_many :bundles, through: :bundle_products
    
    # Validations 
    #
    validates_presence_of :name, :df_price, :vat_rate, :slug
    # We check presence of sku if set in global config
    validates :sku, presence: true, if: proc { Glysellin.autoset_sku }
    # Prices validation
    validates_numericality_of :df_price, :vat_rate
        
    # Callbacks
    #
    # We always check we have a slug for our product
    # And as for the validation, if the SKU is configured to be autoset, we check generate it
    before_validation do
      self.slug = self.name.to_slug
      self.sku = self.generate_sku unless (self.sku && self.sku.length > 0) || !Glysellin.autoset_sku
    end
            
    class << self
      # Find products with taxonomy slugs or taxonomies
      #
      # @param *[Taxonomy, String] taxonomies One or more taxonomy objects or slug strings
      #
      # @return [ActiveRecord::Relation] the products that correspond to the taxonomies passed
      def with_taxonomy *taxonomies
        # Ensure we only have slugs so we got a string vector
        taxonomies.map! { |t| t.kind_of?(Taxonomy) ? t.slug : t }
        # Get products with those taxonomies
        Product.join(:glysellin_products_taxonomies).includes(:taxonomies).where('glysellin_taxonomies.slug IN (?)', taxonomies)
      end
    end
  end
end