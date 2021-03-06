Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users, only: :show do
        resources :sleeps, only: %i[index create update]
        resources :followings, only: :index
        resources :following_sleeps, only: :index
      end

      resources :followings, only: %i[create destroy]
    end
  end
end
