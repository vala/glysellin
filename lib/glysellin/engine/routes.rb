module ActionDispatch::Routing
  class Mapper
    def glysellin_at(mount_location)
      scope mount_location, :module => 'glysellin' do
        resources :orders, :only => [:new, :create, :edit, :update] do
          collection do
            match 'cart', :action => 'cart', :as => 'cart'
            post 'validate-cart', :action => 'validate_cart', :as => 'validate_cart'
            get 'addresses', :action => 'fill_address', :as => 'fill_address'
            post 'validate-addresses', :action => 'validate_addresses', :as => 'validate_addresses'
            get 'checkout', :action => 'checkout', :as => 'checkout'
            post 'offline-payment', :action => 'offline_payment', :as => 'offline_payment'
            post 'process_order', :action => 'process_order', :as => 'process'
            match 'response', :action => 'payment_response', :as => 'payment_response'
            # Routes to handle statically parametered Gateways
            post 'gateway/:gateway', :action => 'gateway_response', :as => 'named_gateway_response'
            post 'gateway/response/:type', :action => 'payment_response', :as => 'typed_payment_response'
          end
          member do
            get 'payment', :action => 'payment', :as => 'payment'
            post 'gw-resp/:goid', :action => 'gateway_response', :as => 'gateway_response'
            match 'response', :action => 'payment_response', :as => 'payment_response'
          end
        end

        resources :products do
          collection do
            get 'filter', :action => 'filter', :as => 'filter'
          end
        end

        root :to => 'products#index'
      end
    end
  end
end
