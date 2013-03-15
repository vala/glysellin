module Glysellin
  class ProductsController < ApplicationController
    def index
      @products = Glysellin::Product.order('created_at DESC').limit(10)
      @products = @products.with_taxonomy(params[:taxonomy_id]) if params[:taxonomy_id]
    end

    def show
      @product = Glysellin::Product.find_by_slug(params[:id])
    end
  end
end
