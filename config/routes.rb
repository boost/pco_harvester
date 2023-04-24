require 'sidekiq/web'

Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :content_partners, only: %i[index show create update new edit] do
    resources :extraction_definitions, only: %i[show new create edit update destroy] do
      member do
        post :test
      end

      resources :jobs, only: %i[show create]
    end
  end

  get :jobs, to: 'jobs#index', as: :jobs

  mount Sidekiq::Web => '/sidekiq'
end
