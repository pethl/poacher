Rails.application.routes.draw do
  get 'vacuum_pouch_calculator/new'
  get 'vacuum_pouch_calculator/create'
  resources :cleaning_foreign_body_checks do
    collection do
      get :week_view
      get :edit_by_date
    end
  end
  
  resources :scale_checks do
    collection do
      get :week_view
    end
  end
  
  
  resources :grading_notes do
    collection do
      get :preload
      post :create_preloaded
    end
  end
  
  resources :invoices do
    collection do
      get :summary
    end
  end
  
  resources :market_sales do
    collection do
      get :summary
    end
  end

  resources :palletised_distributions
  
  resources :milk_quality_monitors do
    collection do
      post :import
      get :rolling_geo_average
    end
  end

  resources :batch_weights
  
  get "breakages/create_month"
  resources :breakages
  
  get "chillers/create_month"
  resources :chillers
  
  get "butter_makes/create_month"
  resources :butter_makes
  resources :waste_records
  
  resources :traceability_records do
    resources :waste_records, except: [:index, :show]
  end
  
  resources :butter_stocks
  
  resources :samples do 
    collection { post :import }
  end
  
  resources :staffs

  resources :contacts do
    member do
      get :search_makesheets
      post :link_makesheets
    end
  end
  devise_for :users

  root "pages#home"
  resources :calculations
  resources :references
  resources :wash_picksheets
  
  get "washes/wash_home"
  resources :washes
  
  get "pages/home"
  get "pages/dairy_home"
  get "pages/nursery_home"
  get "pages/store_home"
  get "pages/wash_home"
  get "pages/cutting_home"
  get "pages/office_home"
  get "pages/sales_home"
  get "pages/mgmt_home"
  get "pages/credits"
  get "/goodbye", to: "pages#goodbye", as: :goodbye
 
  get "/print_picksheet_pdf" => "picksheets#print_picksheet_pdf" 
  #get "/print_makesheet_pdf" => "makesheets#print_makesheet_pdf" 
  get "/makesheets_print_makesheet_pdf" => "makesheets#print_makesheet_pdf" 
  get 'makesheets/:id/print_pdf', to: 'makesheets#print_makesheet_pdf', as: 'print_makesheet_pdf'
  get "makesheets_search" => "makesheets#makesheet_search" 
  get "/print_washsheet_pdf" => "washes#print_washsheet_pdf"
 
  get "makesheets/makesheet_search"
  get "makesheets/graded_blackboard"
  get "makesheets/monthly_summary"
  get "makesheets/overview"
  
#  get "makesheets/batch_turns/:id", :controller => "makesheets", :action => "batch_turns"
# get "makesheets/:id/batch_turns", to: "makesheets/batch_turns"
   
resources :makesheets  do
  member do
    get 'batch_turns'
    get 'summary'
  end
  collection do
    get 'yield_dashboard' #  new collection route (for the dashboard)
  end
 end

 resources :turns
   
  resources :picksheets do
    resources :picksheet_items, except: [:index, :show]
  
    collection do
      get :open_picksheets
      get :assigned_picksheets
      get :cutting_picksheets
      get :shipped_picksheets
      get :daily_cheese_manifest
      get :print_manifest_pdf
      get :print_dispatch_pdf
      get :dispatch_and_collection
      patch :move_to_cutting_room 
    end
  end
   
  match '/users',   to: 'users#index',   via: 'get'

  get  'vacuum_pouch_calculator', to: 'vacuum_pouch_calculator#new'
  post 'vacuum_pouch_calculator', to: 'vacuum_pouch_calculator#create'

 
end
