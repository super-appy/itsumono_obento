Rails.application.routes.draw do

  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :recipes do
    collection do
      get :posted
    end
    resources :recipe_ingredients
    resources :recipe_steps
  end
  namespace :api do
    resources :recipes, only: %i[ new create ]
  end
  resources :bookmarked_recipes do
    collection do
      get :want_to_cook
      get :cooked
    end
  end

  resources :lunchbox_logs do
    collection do
      get :liked_lunchbox_logs
    end
  end
  resources :like_lunchbox_logs, only: %i[create destroy]
  resource :profile, only: %i[show edit update]


  get 'login', to:'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete'logout', to: 'user_sessions#destroy'

  get 'mypage', to:'static_pages#mypage'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_use', to: 'static_pages#terms_of_use'

end
