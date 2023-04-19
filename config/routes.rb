Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'home#index'
  resources :content_partners, only: %i[index show create update new edit] do
    resources :extraction_definitions, only: %i[show new create edit update]
  end
end
