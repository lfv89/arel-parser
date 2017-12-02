Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create]
      resources :segments, only: %i[create]
      resources :segmentations, only: %i[show]
    end
  end
end
