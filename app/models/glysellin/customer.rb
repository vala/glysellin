module Glysellin
  # The Customer class is the middle-man between the main app's User class and 
  class Customer < ActiveRecord::Base
    self.table_name = 'glysellin_customers'
    
    # Relations
    #
    # 
    has_many :orders
    belongs_to :user, class_name: Glysellin.user_class_name
    
    # Check if customer is not an existing user in the main app
    # 
    # @return [Boolean] true or false depending on the customer being a registered user or not
    def anonymous?
      @_anonymous ||= !!user
    end

    # Creates an anonymous user
    # 
    # @return [Boolean] wether or not the user was created
    def self.anonymous!
      create
    end
    
    # get customer's base user
    #
    # @return [User] the user bound to the Customer instance
    def base_user
      user unless anonymous?
    end

    # Recover customer's shipping addresses from his orders
    # 
    # @return [Address, Array] the found addresses or an empty array
    def shipping_addresses
      orders.length > 0 ? Address.where('shipping_address_id IN (?)', orders) : []
    end

    # Recover customer's billing addresses from his orders
    #
    # @return [Address, Array] the found addresses or an empty array
    def billing_addresses
      orders.length > 0 ? Address.where('billing_address_id IN (?)', orders) : []
    end
    
  end
end
