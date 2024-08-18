Rails.application.routes.draw do
  root "pages#home"

  get "pages/home"
  get "pages/overview"
  get "makesheets/dairy_home"
  get "makesheets/nursery_home"
  get "makesheets/makesheet_search"
#  get "makesheets/batch_turns/:id", :controller => "makesheets", :action => "batch_turns"
 # get "makesheets/:id/batch_turns", to: "makesheets/batch_turns"
  get "turns/store_home"
  get "picksheets/sales_home"
  
  resources :makesheets  do
  member do
    get 'batch_turns'
  end
 end
  resources :turns
   get "/print_picksheet_pdf" => "picksheets#print_picksheet_pdf" 
   
  resources :picksheets do
    resources :picksheet_items, except: [:index, :show]
  end
  
 
end
