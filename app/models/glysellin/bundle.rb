module Glysellin
  # Public: Bundles are product packs that can contain one or more products with
  #   their own properties and price, just like simple products.
  class Bundle < ActiveRecord::Base
    include ProductMethods

    self.table_name = 'glysellin_bundles'

    attr_accessible :description, :eot_price, :name, :sku, :slug, :vat_rate, :products, :images, :price

    # Associations
    #
    # The ProductImage model is used for products and bundles
    has_many :images, as: :imageable, class_name: 'Glysellin::ProductImage'
    # Taxonomies can be bound to bundles like product taxonomies
    has_and_belongs_to_many :taxonomies, join_table: 'glysellin_bundles_taxonomies'
    # N..N relation between bundles and products
    has_many :bundle_products, class_name: 'Glysellin::BundleProduct'
    has_many :products, through: :bundle_products, class_name: 'Glysellin::Product'


    # Validations
    #
    #
    validates_presence_of :name, :eot_price, :vat_rate, :slug
    # As for products, we can automatically set the SKU if asked in config file
    validates :sku, presence: true, if: Proc.new { Glysellin.autoset_sku }
    validates_numericality_of :eot_price, :vat_rate

    # Callbacks
    #
    # We always check we have a slug for our product
    # And as for the validation, if the SKU is configured to be autoset, we check generate it
    before_validation do
      self.slug = self.name.to_slug
      self.sku = self.generate_sku unless (self.sku && self.sku.length > 0) || !Glysellin.autoset_sku
    end
  end
end