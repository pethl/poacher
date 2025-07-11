class LocationAssignmentsController < ApplicationController
  require "ostruct"


  def new
    @location_assignment = OpenStruct.new(location_id: params[:location_id])
  end

  def create
    makesheet_id = params[:makesheet_id]
    location_id  = params[:location_id]
  
    if makesheet_id.blank? || location_id.blank?
      redirect_to new_location_assignment_path, alert: "❗ Please select both a make date and a location."
      return
    end
  
    location  = Location.find(location_id)
    makesheet = Makesheet.find(makesheet_id)
  
    if Makesheet.exists?(location_id: location.id)
      redirect_to new_location_assignment_path, alert: "❗ That location is already assigned to another make date."
    else
      makesheet.update(location: location)
      redirect_to new_location_assignment_path,  notice: " Make #{makesheet.make_date.strftime("%d-%m-%y")} assigned to #{location.name}"
    end
  end
  
  
  

  def location_report
    @locations = Location.includes(:makesheet)
  
    trolley_locs = @locations.select { |l| l.location_type == "Trolley" }
    @trolley_data = chart_data_for_scope(trolley_locs)
    @trolley_percent = percentage_full(trolley_locs)
  
    shed_4 = @locations.select { |l| l.name.include?("Shed 4") && l.location_type == "Aisle" }
    shed_5 = @locations.select { |l| l.name.include?("Shed 5") && l.location_type == "Aisle" }
  
    @shed_4_locations = shed_4
    @shed_5_locations = shed_5
  
    @shed_4_aisle_data = chart_data_for_scope(shed_4)
    @shed_5_aisle_data = chart_data_for_scope(shed_5)
  
    @shed_4_percent = percentage_full(shed_4)
    @shed_5_percent = percentage_full(shed_5)
  end
  
  private
  
  def chart_data_for_scope(locations)
    ids = locations.map(&:id)
    occupied_ids = Makesheet.where(location_id: ids).pluck(:location_id).uniq
  
    full_count = ids.count { |id| occupied_ids.include?(id) }
    empty_count = ids.size - full_count
  
    { "Full" => full_count, "Empty" => empty_count }
  end
  
  def percentage_full(locations)
    return 0 if locations.empty?
  
    ids = locations.map(&:id)
    occupied_ids = Makesheet.where(location_id: ids).pluck(:location_id).uniq
    ((occupied_ids.size.to_f / ids.size) * 100).round
  end
end
