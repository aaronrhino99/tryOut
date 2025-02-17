Rails.application.routes.draw do

  devise_for :users
  root to: 'home#Index'

  resources :songs do
    collection do 
      get 'search_youtube'
    end
  end

  resources : playlists do
    member do 
      post    'add_song'
      delete  'remove_song'
    end
  end
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :songs,     only: [:index, show]
      resources :playlists, only: [:index, :show]
    end
  end
  #Sidekiq web interface
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end 

end
