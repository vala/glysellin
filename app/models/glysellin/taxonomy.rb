module Glysellin
  class Taxonomy < ActiveRecord::Base
    has_and_belongs_to_many :products, :join_table => 'glysellin_products_taxonomies'
  end
end
