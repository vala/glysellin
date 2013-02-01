module ActionDispatch::Routing
  class Mapper
    def glysellin_at(mount_location)
      scope mount_location, :module => 'glysellin' do
        resources :orders, :only => [:new, :create, :edit, :update] do
          collection do
            get 'cart'
            post 'validate_cart'
            get 'checkout'
            post 'offline_payment'
            post 'process_order', :as => 'process'
            get 'payment_response'
            # Routes to handle statically parametered Gateways
            post 'gateway/:gateway', :action => 'gateway_response', :as => 'named_gateway_response'
            match 'gateway/response/:type', :action => 'payment_response', :as => 'typed_payment_response'
            get 'create-from-cart', :action => 'create_from_cart', :as => 'from_cart_create'
          end
          member do
            put 'process_order', :as => 'process'
            get 'addresses'#, :action => 'fill_addresses', :as => 'fill_addresses'
            post 'validate_addresses'
            get 'payment_method'
            get 'payment'
            post 'gw-resp/:goid', :action => 'gateway_response', :as => 'gateway_response'
            match 'payment_response'
          end
        end

        resources :products do
          collection do
            get 'filter'
          end
        end

        resource :cart, controller: 'cart', only: [:show] do
          post "add-product", action: "add", as: "add_to"
        end

        root :to => 'products#index'
      end
    end
  end
end
