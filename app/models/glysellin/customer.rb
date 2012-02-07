module Glysellin
  class Customer < ActiveRecord::Base
    has_many :orders
    belongs_to :user
    
    def anonymous?
      !!user
    end

    # Creates an anonymous user
    def self.anonymous!
      create
    end
    
    def base_user
      user
    end

    def shipping_addresses
      orders.length > 0 ? orders.map(&:shipping_address) : []
    end

    def billing_addresses
      orders.length > 0 ? orders.map(&:billing_address) : []
    end
    
  end
end
