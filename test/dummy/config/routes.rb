Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  mount Glysellin::Engine => "/shop"
  root :to => 'home#index'
end
