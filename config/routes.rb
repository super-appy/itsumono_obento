Rails.application.routes.draw do

  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :recipes do
    collection do
      get :new_api
    end
    resources :recipe_ingredients
    resources :recipe_steps
  end

  get 'login', to:'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete'logout', to: 'user_sessions#destroy'
end
