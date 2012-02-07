module Glysellin
  class Address < ActiveRecord::Base
    has_many :orders
  end
end
