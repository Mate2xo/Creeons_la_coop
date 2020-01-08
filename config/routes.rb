# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, skip: :registrations
  as :member do
    get 'members/edit', to: "devise_invitable/registrations#edit", as: "edit_member_registration"
    put 'members', to: "devise_invitable/registrations#update", as: "member_registration"
  end

  ActiveAdmin.routes(self)
  root 'static_pages#home'
  get 'en_savoir_plus', to: "static_pages#about_us", as: 'about_us'

  resources :missions
  post 'missions/:id/enroll', to: "missions#enroll", as: "enroll_in_mission"
  delete 'missions/:id/enroll', to: "missions#disenroll"

  resources :productors
  resources :infos
  resources :documents
  resources :members, only: %i[index show edit update]
  mount Thredded::Engine => '/forum'
end
