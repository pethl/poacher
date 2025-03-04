class PagesController < ApplicationController
  def home
    
  end
  
  def dairy_home
  end

  def store_home
  end
  
  def wash_home
  end
  
  def cutting_home
    @open_picksheets_count = Picksheet.where(status: "Open").count
    @assigned_picksheets_count = Picksheet.where(status: "Assigned").count
  end

  def office_home
  end
  
  def mgmt_home
  end
  
  def search
    make_date= params[:make_date]
    puts make_date
    make_date =  DateTime.parse make_date
    @makesheet = Makesheet.where(make_date: make_date).first.id
   
    #redirect_to print_makesheet_pdf_path(:id => @makesheet)
     redirect_to print_makesheet_pdf_path(:id => @makesheet)
     return
  end

end
