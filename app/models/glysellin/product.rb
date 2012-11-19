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
    has_many :images, as: :imageable, :class_name => 'Glysellin::ProductImage',
      :inverse_of => :imageable

    # Can have multiple taxonomies
    has_and_belongs_to_many :taxonomies, :class_name => 'Glysellin::Taxonomy',
      join_table: 'glysellin_products_taxonomies', :foreign_key => 'product_id'

    # N..N relation between bundles and products
    has_many :bundle_products, :class_name => 'Glysellin::BundleProduct'
    has_many :bundles, through: :bundle_products,
      :class_name => 'Glysellin::Bundle'

    # Products can belong to a brand
    belongs_to :brand, :inverse_of => :products

    has_many :properties, :class_name => 'Glysellin::ProductProperty'

    accepts_nested_attributes_for :images

    attr_accessible :description, :eot_price, :name, :sku, :slug, :vat_rate,
      :brand, :taxonomies, :images, :properties, :in_stock, :price, :published,
      :taxonomies, :display_priority, :images_attributes, :taxonomy_ids

    # Validations
    #
    validates_presence_of :name, :eot_price, :vat_rate, :slug
    # We check presence of sku if set in global config
    validates :sku, presence: true, if: proc { Glysellin.autoset_sku }
    # Prices validation
    validates_numericality_of :eot_price, :vat_rate, :price,
      :display_priority
    validates_numericality_of :in_stock, if: proc { |p| p.in_stock.presence }

    # Callbacks
    #
    # We always check we have a slug for our product
    # And as for the validation, if the SKU is configured to be autoset,
    # we check generate it
    before_validation do
      self.slug = self.name.to_slug
      unless (self.sku && self.sku.length > 0) || !Glysellin.autoset_sku
        self.sku = self.generate_sku
      end

      if !self.vat_rate
        self.vat_rate = Glysellin.default_vat_rate
      end
      # If we have to fill one of the prices when changed
      if (self.eot_price_changed? && !self.price_changed?) ||
          (self.new_record? && self.eot_price && !self.price)
        self.price = self.eot_price * self.vat_ratio
      elsif self.price_changed? || (self.new_record? && self.price)
        self.eot_price = self.price / self.vat_ratio
      end
    end

    class << self
      # Find products with taxonomy slugs or taxonomies
      #
      # @param *[Taxonomy, String] taxonomies One or more taxonomy objects or
      #   slug strings
      #
      # @return [ActiveRecord::Relation] the products that correspond to the
      #   taxonomies passed
      def with_taxonomy *taxonomies
        # Ensure we only have slugs so we got a string vector
        taxonomies.map! { |t| t.kind_of?(Glysellin::Taxonomy) ? t.slug : t }
        # Get products with those taxonomies
        Product.includes(:taxonomies).
          where('glysellin_taxonomies.slug IN (?)', taxonomies)
      end
    end

    def vat_ratio
      1 + vat_rate / 100
    end

  end
end