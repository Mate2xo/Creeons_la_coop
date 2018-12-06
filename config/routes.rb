Rails.application.routes.draw do
  devise_for :members
  root 'static_pages#home'
  get 'dashboard', to: "static_pages#dashboard"

  get 'admin', to: "admin#show"


  resources :productors, only: [:index, :show, :edit]
  resources :infos, only: [:index, :show, :edit]
  resources :missions, only: [:index, :show, :edit]
  resources :members, only: [:index, :show, :edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
