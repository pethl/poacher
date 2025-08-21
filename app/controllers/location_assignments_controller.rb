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
  
    # Only warn/soft-check if location is Aisle or Trolley
    if %w[Aisle Trolley].include?(location.location_type)
      if Makesheet.exists?(location_id: location.id)
        flash[:notice] = "⚠️ This location was previously filled – assigning anyway."
      end
    end
  
    makesheet.update(location: location)
    redirect_to new_location_assignment_path, notice: "Make #{makesheet.make_date.strftime("%d-%m-%y")} assigned to #{location.name}"
  end
  

  def location_report
    @locations = Location.includes(:makesheet)
  
   # OLD CODE for unique trolleys trolley_locs = @locations.select { |l| l.location_type == "Trolley" }
   # Trolleys General – treat as 100 virtual slots
   # Trolleys General – treat as 100 virtual slots
   trolley = Location.find_by(name: "Trolley - General")
   occupied = trolley.present? ? trolley.all_makesheets.count : 0
   capacity = 100

      @trolley_data    = { "Full" => occupied, "Empty" => capacity - occupied }
      @trolley_percent = ((occupied.to_f / capacity) * 100).round
  
    shed_4 = @locations.select { |l| l.name.include?("Shed 4") && l.location_type == "Aisle" }
    shed_5 = @locations.select { |l| l.name.include?("Shed 5") && l.location_type == "Aisle" }
  
    @shed_4_locations = shed_4
    @shed_5_locations = shed_5
  
    @shed_4_aisle_data = chart_data_for_scope(shed_4)
    @shed_5_aisle_data = chart_data_for_scope(shed_5)
  
    @shed_4_percent = percentage_full(shed_4)
    @shed_5_percent = percentage_full(shed_5)


    @empty_shed_4 = Location
    .left_joins(:makesheet)
    .where("locations.name ILIKE ?", "Shed 4%")
    .where(makesheets: { id: nil })
    .order(:name)
  
   # Shed 4: group by aisle, then side, then sort by column_number (1..9), with nils last
        @empty_shed_4_grouped = @empty_shed_4
        .group_by(&:aisle)                                     # { aisle => [locations] }
        .sort_by { |aisle, _| aisle || 999 }                   # numeric aisle order, nils last
        .to_h
        .transform_values do |locations|
          locations
            .group_by(&:side)                                  # { "Left" => [...], "Right" => [...], nil => [...] }
            .sort_by { |side, _| side == "Left" ? 0 : side == "Right" ? 1 : 2 } # Left, Right, Unknown
            .to_h
            .transform_values { |locs| locs.sort_by { |loc| [loc.column_number || 999, loc.name] } }
        end
  
  @empty_shed_5 = Location
    .left_joins(:makesheet)
    .where("locations.name ILIKE ?", "Shed 5%")
    .where(makesheets: { id: nil })
    .order(:name)
  
    @empty_shed_5_grouped = @empty_shed_5
    .group_by(&:aisle)
    .sort_by { |aisle, _| aisle || 999 }
    .to_h
    .transform_values do |locations|
      locations
        .group_by(&:side)
        .sort_by { |side, _| side == "Left" ? 0 : side == "Right" ? 1 : 2 }
        .to_h
        .transform_values { |locs| locs.sort_by { |loc| [loc.column_number || 999, loc.name] } }
    end
  
    @empty_trolleys = Location
    .left_joins(:makesheet)
    .where("locations.name ILIKE ?", "Trolley%")
    .where(makesheets: { id: nil })
    .sort_by(&:trolley_number) # this happens in Ruby after the query

    #new section for 
    @unassigned_makesheets = Makesheet
  .where(location_id: nil)
  .where("make_date >= ?", 6.months.ago.to_date)  # optional filter
  .order(make_date: :desc)
  
  end

  def inspection_results
    @shed  = params[:shed] || "Shed 4"
    @aisle = (params[:aisle] || 1).to_i
  
    @locations = Location
      .includes(:makesheet)
      .where("name ILIKE ?", "#{@shed} - Aisle #{@aisle} %")
      .sort_by do |loc|
        side = loc.side == "Left" ? 0 : 1
        col  = loc.name[/Col (\d+)/, 1].to_i
        [side, col]
      end
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
