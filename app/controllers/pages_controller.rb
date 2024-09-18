class PagesController < ApplicationController
  def home
    @makesheets = Makesheet.all
  end
  
  def overview
  end
  
  def wash_home
  end
end
