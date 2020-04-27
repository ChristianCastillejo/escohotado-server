Rails.application.routes.draw do
  resources :articles
  get 'search_articles', to: 'articles#search_by_tags'
  resources :videos
  get 'search_videos', to: 'videos#search_by_tags'
  get 'random_videos', to: 'videos#random_video'
  post 'login', to: 'authentication#authenticate'
  get 'loggedinuser', to: 'users#current'
end