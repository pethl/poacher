class PagesController < ApplicationController
  def home
    @makesheets = Makesheet.all
  end
  
  def overview
  end
  
  def wash_home
      @todays_wash = Wash.last
      @wash_approved =  Wash.where(wash_status: "Approved").last
  end
  
  def dairy_home
    @makesheets = Makesheet.order('make_date DESC')
  #  @makesheets = @makesheets.last(7)
 
  end
  
  def nursery_home
    @makesheets = Makesheet.where(grade: "").order('make_date DESC')
  end
  
  def sales_home
    @picksheets = Picksheet.all.order(:date_order_placed)
  end
  
  def store_home
    @turns = Turn.order('turn_date DESC')
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
