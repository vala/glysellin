module Glysellin
  class Taxonomy < ActiveRecord::Base
    extend FriendlyId

    self.table_name = 'glysellin_taxonomies'

    friendly_id :name, use: :slugged

    has_and_belongs_to_many :products,
      join_table: 'glysellin_products_taxonomies'
    has_many :sub_taxonomies, class_name: 'Taxonomy',
      foreign_key: 'parent_taxonomy_id'
    belongs_to :parent_taxonomy, foreign_key: 'parent_taxonomy_id',
      class_name: 'Taxonomy'

    attr_accessible :name, :parent_taxonomy, :sub_taxonomies, :products,
      :product_ids, :sub_taxonomy_ids, :parent_taxonomy_id

    def all_products
      Product.includes(:taxonomies).where(
        'glysellin_products_taxonomies.taxonomy_id IN (?)',
        taxonomy_tree_ids
      )
    end

    def taxonomy_tree_ids
      if sub_taxonomies.length > 0
        ts = sub_taxonomies.includes(:sub_taxonomies).map(&:taxonomy_tree_ids)
        ts.flatten << self.id
      else
        self.id
      end
    end
  end
end
