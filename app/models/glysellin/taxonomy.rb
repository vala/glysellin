module Glysellin
  class Taxonomy < ActiveRecord::Base
    include ModelInstanceHelperMethods
    
    self.table_name = 'glysellin_taxonomies'
    
    attr_accessible :name, :parent_taxonomy, :sub_taxonomies, :products
    
    has_and_belongs_to_many :products, :join_table => 'glysellin_products_taxonomies'
    
    has_many :sub_taxonomies, :class_name => 'Taxonomy', :foreign_key => 'parent_taxonomy_id'
    belongs_to :parent_taxonomy, :foreign_key => 'parent_taxonomy_id', :class_name => 'Taxonomy'
    
    before_validation do
      self.slug = self.name.to_slug
    end
    
    def all_products
      Product.includes(:taxonomies).where('glysellin_products_taxonomies.taxonomy_id IN (?)', taxonomy_tree_ids)
    end
    
    def taxonomy_tree_ids
      sub_taxonomies.length > 0 ? sub_taxonomies.includes(:sub_taxonomies).map(&:taxonomy_tree_ids).flatten : self.id
    end
  end
end
