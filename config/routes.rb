Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :invites
  resources :groups
  root to: 'welcome#index'
end
