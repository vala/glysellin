module Glysellin
  class Customer < ActiveRecord::Base
    has_many :orders
    belongs_to :user
    
    # is some existing user in the main app ?
    def anonymous?
      !!user
    end

    # Creates an anonymous user
    def self.anonymous!
      create
    end
    
    # get the user the customer's 
    def base_user
      user
    end

    # Recover shipping addresses of the customer from his orders
    def shipping_addresses
      orders.length > 0 ? orders.map(&:shipping_address) : []
    end

    # Recover billing addresses of the customer from his orders
    def billing_addresses
      orders.length > 0 ? orders.map(&:billing_address) : []
    end
    
  end
end
