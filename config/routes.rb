Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  get 'filter_groups' => 'application#filter_groups'
  resources :users, only: [:index, :show]
  resources :invites do
    member do
      get :accept
      get :decline
    end
  end
  resources :groups do
    resources :entries, only: [:index, :new, :create, :destroy]
    resources :comments, only: [:index, :new, :create]
  end
  root to: 'welcome#index'
end
