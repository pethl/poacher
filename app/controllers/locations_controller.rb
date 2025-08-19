class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  def shed_map
    shed_number = params[:shed]
    @shed_name = "Shed #{shed_number}"
  
    # 💡 Handle 'Find It' redirect if a makesheet was selected
    if params[:makesheet_id].present?
      makesheet = Makesheet.find_by(id: params[:makesheet_id])
  
      if makesheet&.location.present?
        return redirect_to shed_map_path(shed: shed_number, anchor: "location-#{makesheet.location.id}")
      else
        flash.now[:alert] = "No location found for that makesheet."
      end
    end
  
    @shed_locations = Location
      .where("name LIKE ?", "%Shed #{shed_number}%")
      .includes(:makesheet)
      .group_by(&:row_label)
  
    @max_columns = @shed_locations.values.flatten.map(&:column_number).compact.max
  
    unless @shed_locations.present?
      redirect_to root_path, alert: "Shed not found"
    end
  end
  
  

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_path, status: :see_other, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def print_labels
    locations = []
  
    # Individual location print
    if params[:id].present?
      locations = [Location.find_by(id: params[:id])].compact
  
    # Range print (all location types)
    elsif params[:location_start].present? && params[:location_end].present?
      start_id = params[:location_start].to_i
      end_id   = params[:location_end].to_i
  
      start_location = Location.find_by(id: start_id)
      end_location   = Location.find_by(id: end_id)
  
      if start_location && end_location
        start_order = [start_location.sort_order, end_location.sort_order].min
        end_order   = [start_location.sort_order, end_location.sort_order].max
  
        locations = Location.where(sort_order: start_order..end_order)
                            .order(:sort_order)
      end
    end
  
    # Generate PDF or redirect if nothing matched
    if locations.any?
      label_data = locations.map { |loc| { location: loc, url: location_url(loc) } }
  
      pdf_data = LocationLabelPdfService.new(label_data).generate
  
      send_data pdf_data,
                filename: "location-labels.pdf",
                type: "application/pdf",
                disposition: "inline"
    else
      redirect_to locations_path, alert: "No matching locations found to print."
    end
  end

  def print_markers
    aisle_name = params[:aisle_name]
  
    if aisle_name.present?
      if aisle_name == "ALL"
        unique_marker_names = Location.pluck(:name)
                                      .map { |n| n[%r{^Shed \d+ - Aisle \d+ (Left|Right)}] }
                                      .compact.uniq.sort
      
        matching_locations = unique_marker_names.map { |marker_name| first_location_for_marker(marker_name) }.compact
      else
        matching_locations = [first_location_for_marker(aisle_name)].compact
      end
  
      if matching_locations.any?
        pdf_data = AisleMarkerPdfService.new(matching_locations).generate
  
        send_data pdf_data,
                  filename: "aisle-markers.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      else
        redirect_to locations_path, alert: "No matching locations found."
      end
    else
      redirect_to locations_path, alert: "Please select an aisle to print."
    end
  end

  # GET /locations/duplicate_assignments
def duplicate_assignments
  @duplicate_locations = Makesheet
    .where.not(location_id: nil)
    .group(:location_id)
    .having("COUNT(*) > 1")
    .count

  @locations_by_id = Location.where(id: @duplicate_locations.keys).index_by(&:id)

  @makesheets_by_location = Makesheet
    .where(location_id: @duplicate_locations.keys)
    .includes(:location)
    .order(:location_id, :make_date)
    .group_by(&:location_id)
end

# POST /locations/:id/clear_location_assignment
def clear_location_assignment
  location = Location.find(params[:id])
  makesheet = location.makesheet

  if makesheet.present?
    makesheet.update_columns(location_id: nil, updated_at: Time.current)
    notice = "Cleared makesheet #{makesheet.id} from #{location.name}"
  else
    notice = "No makesheet currently assigned to that location."
  end

  redirect_back fallback_location: duplicate_assignments_locations_path, notice: notice
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:name, :location_type, :sort_order, :active)
    end

    def first_location_for_marker(name)
      Location.where("name ILIKE ?", "#{name}%").order(:sort_order).first
    end
end
