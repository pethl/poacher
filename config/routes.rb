Rails.application.routes.draw do
  resources :staffs
  resources :contacts
  devise_for :users

  root "pages#home"
  resources :calculations
  resources :references
  resources :wash_picksheets
  
  get "washes/wash_home"
  resources :washes
  
  get "pages/admin_home"
  get "pages/home"
  get "pages/overview"
  get "pages/cutting_home"
  get "pages/dairy_home"
  get "pages/nursery_home"
  get "pages/store_home"
  get "pages/sales_home"
  get "pages/search"
  get "pages/mgmt_home"
 
  get "/print_picksheet_pdf" => "picksheets#print_picksheet_pdf" 
  get "/print_makesheet_pdf" => "makesheets#print_makesheet_pdf" 
  get "/makesheets_print_makesheet_pdf" => "makesheets#print_makesheet_pdf" 
  get "makesheets_search" => "makesheets#makesheet_search" 
  get "/print_washsheet_pdf" => "washes#print_washsheet_pdf"
 
  get "makesheets/makesheet_search"
#  get "makesheets/batch_turns/:id", :controller => "makesheets", :action => "batch_turns"
# get "makesheets/:id/batch_turns", to: "makesheets/batch_turns"
  
  resources :makesheets  do
  member do
    get 'batch_turns'
  end
 end
  resources :turns
   
  resources :picksheets do
    resources :picksheet_items, except: [:index, :show]
  end
 
end
