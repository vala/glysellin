require 'digest/sha1'

module Glysellin
  class Product < ActiveRecord::Base
    include ModelInstanceHelperMethods
    include ProductMethods

    self.table_name = 'glysellin_products'

    # Relations
    #
    # The ProductImage model is used for products and bundles with the same
    has_many :images, as: :imageable, class_name: 'Glysellin::ProductImage',
      inverse_of: :imageable, dependent: :destroy

    # Can have multiple taxonomies
    has_and_belongs_to_many :taxonomies, :class_name => 'Glysellin::Taxonomy',
      join_table: 'glysellin_products_taxonomies', :foreign_key => 'product_id'

    # N..N relation between bundles and products
    # has_many :bundle_products, class_name: 'Glysellin::BundleProduct',
    #   foreign_key: 'product_id'
    # has_many :bundles, class_name: 'Glysellin::Product',
    #   through: :bundle_products

    # # Bundled products in current_product
    # has_many :product_bundles, class_name: 'Glysellin::BundleProduct',
    #   foreign_key: 'bundle_id'
    # has_many :bundled_products, class_name: 'Glysellin::Product',
    #   through: :product_bundles

    # Products can belong to a brand
    belongs_to :brand, :inverse_of => :products

    belongs_to :product_type

    has_many :variants, class_name: 'Glysellin::Variant',
      before_add: :set_product_on_variant, dependent: :destroy

    accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

    # accepts_nested_attributes_for :bundled_products, allow_destroy: true, reject_if: :all_blank

    attr_accessible :description, :name, :sku, :slug, :vat_rate,
      :brand, :taxonomies, :images, :published,
      :display_priority, :images_attributes, :taxonomy_ids, :unlimited_stock,
      :position, :brand_id, :variants_attributes, :variants, :product_type_id

      # :bundled_products_attributes

    # Validations
    #
    validates_presence_of :name, :slug
    # Validates price related attributes only unless we have bundled products
    # so we can defer validations to them
    validates :vat_rate, presence: true,
      numericality: true # , unless: proc { |p| p.bundled_products.length > 0 }

    # We check presence of sku if set in global config
    validates :sku, presence: true, if: proc { Glysellin.autoset_sku }

    # Callbacks
    #
    before_validation :set_slug, :set_sku, :set_vat_rate, :ensure_variant

    scope :published, where('glysellin_products.published = ?', true)
    scope :with_taxonomy, lambda { |*taxonomies|
      # Ensure we only have slugs so we got a string vector
      taxonomies.map! { |t| t.kind_of?(Glysellin::Taxonomy) ? t.slug : t }
      # Get products with those taxonomies
      includes(:taxonomies).where('glysellin_taxonomies.slug IN (?)', taxonomies)
    }

    # We always check we have a slug for our product
    def set_slug
      self.slug = name.to_slug
    end

    # And as for the validation, if the SKU is configured to be autoset,
    # we check generate it
    def set_sku
      unless (sku && sku.length > 0) || !Glysellin.autoset_sku
        self.sku = generate_sku
      end
    end

    def set_vat_rate
      if !vat_rate
        self.vat_rate = Glysellin.default_vat_rate
      end
    end

    def ensure_variant
      variants.build(product: self) unless variants.length > 0
    end

    # Fetches all available variants for the current product
    #
    def available_variants
      variants.available
    end

    def image
      images.length > 0 ? images.first.image : nil
    end

    def price
      if self.variants.first
        self.variants.first.price
      end
    end

    def set_product_on_variant variant
      variant.product = self
    end


    # bundle_attribute :price do |product|
    #   product.bundled_products.reduce(0) do |total, product|
    #     total + product.price
    #   end
    # end

    # bundle_attribute :eot_price do |product, att|
    #   product.bundled_products.reduce(0) do |total, product|
    #     total + product.eot_price
    #   end
    # end

    # bundle_attribute :vat_rate do |product|
    #   product.bundled_products.reduce(0) do |total, product|
    #     total + (product.vat_rate * product.price)
    #   end / product.price
    # end
  end
end