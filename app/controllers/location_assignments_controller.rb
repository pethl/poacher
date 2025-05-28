class LocationAssignmentsController < ApplicationController

  def new
    @location_assignment = OpenStruct.new(location_id: params[:location_id])
  end

  def create
    makesheet_id = params[:makesheet_id]
    location_id  = params[:location_id]
  
    if makesheet_id.blank? || location_id.blank?
      redirect_to new_location_assignment_path, alert: "Please select both a make_date and a location."
      return
    end
  
    location   = Location.find(location_id)
    makesheet  = Makesheet.find(makesheet_id)
  
    if Makesheet.exists?(location_id: location.id)
      redirect_to new_location_assignment_path, alert: "That location is already assigned to another make_date."
    else
      makesheet.update(location: location)
      redirect_to pages_store_home_path, notice: "Location assigned."
    end
  end

  def location_report
    @location_types = Location.distinct.pluck(:location_type).compact
    @selected_type = params[:location_type]
  
    @locations = Location.includes(:makesheet)
    @locations = @locations.where(location_type: @selected_type) if @selected_type.present?

     # Simple counts by type
    @trolley_data = chart_data_for_type("trolley")
    @alley_data = chart_data_for_type("alley")
  end

  private

  def chart_data_for_type(type)
    all_locations = Location.where("LOWER(location_type) = ?", type.downcase)
    total = all_locations.count.to_f
  
    used_location_ids = Makesheet.where.not(location_id: nil).pluck(:location_id).uniq
    full = all_locations.where(id: used_location_ids).count
    empty = total - full
  
    if total.zero?
      { "Full" => 0, "Empty" => 0 }
    else
      {
        "Full" => ((full / total) * 100).round(1),
        "Empty" => ((empty / total) * 100).round(1)
      }
    end
  end
  
end

