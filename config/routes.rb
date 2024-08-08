Rails.application.routes.draw do
 
  root "pages#home"

  get "pages/home"
  get "pages/overview"
  get "makesheets/dairy_home"
  get "turns/store_home"
  resources :makesheets
  resources :turns
end
