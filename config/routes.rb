Glysellin::Engine.routes.draw do
  resources :orders, :only => [:new, :create, :edit, :update] do
    collection do
      match 'cart', :action => 'cart', :as => 'cart'
      post 'validate-cart', :action => 'validate_cart', :as => 'validate_cart'
      get 'addresses', :action => 'fill_address', :as => 'fill_address'
      post 'validate-addresses', :action => 'validate_addresses', :as => 'validate_addresses'
      get 'checkout', :action => 'checkout', :as => 'checkout'
      post 'offline-payment', :action => 'offline_payment', :as => 'offline_payment'
      post 'process', :action => 'process', :as => 'process'
    end
    member do
      post 'gw-resp', :action => 'gateway_response', :as => 'gateway_response'
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
