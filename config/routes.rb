Rails.application.routes.draw do
  resources :achievement, only: %i[create update]
  root 'welcome#index'
end
