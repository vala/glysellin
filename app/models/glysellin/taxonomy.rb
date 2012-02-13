module Glysellin
  class Taxonomy < ActiveRecord::Base
    include ModelInstanceHelperMethods
    
    self.table_name = 'glysellin_taxonomies'
    has_and_belongs_to_many :products, :join_table => 'glysellin_products_taxonomies'
    
    has_many :sub_taxonomies, :class_name => 'Taxonomy'#, :foreign_key => 'parent_taxonomy_id'
    belongs_to :parent_taxonomy, :foreign_key => 'parent_taxonomy_id', :class_name => 'Taxonomy'
    
    before_validation do
      self.slug = self.name.to_slug
    end
  end
end
