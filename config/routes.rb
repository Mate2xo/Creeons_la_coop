Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/dashboard'
  get 'productors/index'
  get 'productors/show'
  get 'productors/edit'
  get 'infos/index'
  get 'infos/show'
  get 'infos/edit'
  get 'missions/index'
  get 'missions/show'
  get 'missions/edit'
  get 'members/index'
  get 'members/show'
  get 'members/edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
