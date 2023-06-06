require 'sidekiq/web'

Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: :edit_user_registration
    put 'users/:id' => 'devise/registrations#update', as: :user_registration
    delete 'users' => 'devise/registrations#destroy', as: :registration
  end

  root 'home#index'

  resources :users, only: %i[index show]

  resources :content_sources, only: %i[index show create update new edit] do
    resources :extraction_definitions, only: %i[show new create edit update destroy] do
      collection do
        post :test
        post :test_record_extraction
        post :test_enrichment_extraction
      end
      post :update_harvest_definitions, on: :member

      resources :extraction_jobs, only: %i[show create destroy] do
        post :cancel, on: :member
      end
    end

    resources :transformation_definitions, only: %i[new create show edit update destroy] do
      post :test, on: :collection
      post :update_harvest_definitions, on: :member

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
