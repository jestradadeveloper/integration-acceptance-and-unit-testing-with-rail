Rails.application.routes.draw do
  resources :achievements, only: %i[new create update show]
  root 'welcome#index'
end
