class PagesController < ApplicationController
  def home
    @makesheets = Makesheet.all
  end
  
  def overview
  end
  
  def wash_home
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
end
