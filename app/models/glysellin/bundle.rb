# Public: Bundles are product packs that can contain one or more products with
#   their own properties and price, just like simple products.
class Bundle < ActiveRecord::Base
  include ProductMethods
  attr_accessible :description, :df_price, :name, :sku, :slug, :vat_rate
  
  # Associations
  #
  # The ProductImage model is used for products and bundles
  has_many :images, through: :imageable, class_name: 'ProductImage'
  # Taxonomies can be bound to bundles like product taxonomies
  has_and_belongs_to_many :taxonomies, join_table: 'glysellin_bundles_taxonomies'
  # N..N relation between bundles and products
  has_many :bundle_products
  has_many :products, through: :bundle_products
  
  
  # Validations
  # 
  # 
  validates_presence_of :name, :df_price, :vat_rate, :slug
  # As for products, we can automatically set the SKU if asked in config file
  validates :sku, presence: true, if: Proc.new { Glysellin.autoset_sku }
  validates_numericality_of :df_price, :vat_rate
    
end
