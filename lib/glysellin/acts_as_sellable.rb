module Glysellin
  module ActsAsSellable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_sellable
        has_one :product, :class_name => "::Glysellin::Product", :inverse_of => :item
        accepts_nested_attributes_for :product, :allow_destroy => true
      end
    end
  end
end

::ActiveRecord::Base.send :include, Glysellin::ActsAsSellable