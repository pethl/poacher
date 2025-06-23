Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
 
  get  "/location_assignments/new", to: "location_assignments#new",  as: "new_location_assignment"
  post "/location_assignments",     to: "location_assignments#create", as: "location_assignments"
  get "/location_report", to: "location_assignments#location_report", as: :location_report
  #this is critical never delete
  get '/locations/:id', to: redirect('/location_assignments/new?location_id=%{id}') 

  get "shed/:shed/map", to: "locations#shed_map", as: :shed_map
  
  resources :locations do
    collection do
      get :print_labels
      get :print_wizard
    end
  end

  get 'vacuum_pouch_calculator/new'
  get 'vacuum_pouch_calculator/create'
  resources :cleaning_foreign_body_checks do
    collection do
      get :week_view
      get :edit_by_date
    end
  end

  resources :cheese_wash_records, only: [:new, :create, :edit, :show, :index]
  

  # Optional: root page (if relevant)
  # root "cheese_wash_records#index"
  
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
 
  resources :makesheets do
    member do
      get 'batch_turns'
      get 'summary'
      get :qr_code
      get :print_pdf
    end
  
    collection do
      get 'yield_dashboard'
      get 'makesheet_search'
      get 'graded_blackboard'
      get 'monthly_summary'
      get 'overview'
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
