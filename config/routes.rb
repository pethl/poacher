Rails.application.routes.draw do
  root "pages#home"

  get "pages/home"
  get "pages/overview"
  get "makesheets/dairy_home"
  get "turns/store_home"
  get "picksheets/sales_home"
  resources :makesheets
  resources :turns
   get "/print_picksheet_pdf" => "picksheets#print_picksheet_pdf" 
   
  resources :picksheets do
    resources :picksheet_items, except: [:index, :show]
  end
  
 
end
