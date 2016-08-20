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
  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :new, :create]
  end
  resources :groups do
    get :updated_at, on: :member
    get :get_chart_data, on: :member
    resources :entries, only: [:index, :new, :create, :destroy]
    resources :comments, only: [:index, :new, :create]
  end
  get 'dashboard' => 'dashboard#index'
  root to: 'welcome#index'
end
