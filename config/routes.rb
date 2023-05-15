require 'sidekiq/web'

Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :content_partners, only: %i[index show create update new edit] do
    resources :extraction_definitions, only: %i[show new create edit update destroy] do
      post :test, on: :collection

      resources :extraction_jobs, only: %i[show create destroy] do
        post :cancel, on: :member
      end
    end

    resources :transformation_definitions, only: %i[new create show edit update destroy] do
      post :test, on: :collection

      resources :fields, only: %i[create update destroy] do
        post :run, on: :collection
      end
    end

    resources :harvest_definitions, only: %i[show new create edit update destroy] do
      resources :harvest_jobs, only: %i[show create destroy] do
        post :cancel, on: :member
      end
    end
  end

  get :jobs, to: 'extraction_jobs#index', as: :extraction_jobs

  resources :destinations do
    post :test, on: :collection
  end

  mount Sidekiq::Web => '/sidekiq'
end
