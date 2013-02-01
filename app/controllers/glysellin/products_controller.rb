module Glysellin
  class ProductsController < ApplicationController
    def index
      @products = Product.order('created_at DESC').limit(10)
    end

    def filter
    end

    def show
    end
  end
end
