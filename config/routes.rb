Rails.application.routes.draw do
  resources :posts
  root 'posts#index'
  resources :undo, only: [:destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
