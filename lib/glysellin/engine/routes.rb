module ActionDispatch::Routing
  class Mapper
    def glysellin_at(mount_location, options = {})

      controllers = parse_controllers(options)

      scope mount_location do
        resources :orders, controller: controllers[:orders], :only => [:new, :create, :edit, :update] do
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
            get 'addresses'
            post 'validate_addresses'
            get 'payment_method'
            get 'payment'
            post 'gw-resp/:goid', :action => 'gateway_response', :as => 'gateway_response'
            match 'payment_response'
          end
        end

        resources :products, controller: controllers[:products] do
          collection do
            get 'taxonomy/:id', action: "filter", as: "filter"
          end
        end

        resources :taxonomies, only: [] do
          resources :products, only: [:index]
        end

        resource :cart, controller: controllers[:cart], only: [:show] do
          post "add-product", action: "add", as: "add_to"
          put "update", action: "update", as: "update"
          get "remove-product/:id", action: "remove", as: "remove_from"
        end

        get '/' => 'glysellin/products#index', as: 'shop'
      end
    end

    # Allows user to define app controllers to handle glysellin routes
    def parse_controllers options
      defaults = {
        orders: 'glysellin/orders',
        products: 'glysellin/products',
        cart: 'glysellin/cart'
      }

      defaults.merge(options)
    end
  end
end
