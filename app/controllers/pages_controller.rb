class PagesController < ApplicationController
  def home
    @makesheets = Makesheet.all
  end
  
  def dairy_home
    @makesheets = Makesheet.order('make_date DESC')
  #  @makesheets = @makesheets.last(7)
  end

  def office_home
  end
  
  def nursery_home
    @makesheets = Makesheet.where(grade: "").order('make_date DESC')
  end
  
  def sales_home
    @picksheets = Picksheet.all.order(:date_order_placed)
    @open_orders = Picksheet.where(status: "Open")
    @assigned_orders = Picksheet.where(status: "Assigned")
    @shipped_orders = Picksheet.where(status: "Shipped")
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
