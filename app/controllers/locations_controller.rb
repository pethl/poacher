class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  def shed_map
    shed_number = params[:shed] # expects "4" or "5"
    @shed_name = "Shed #{shed_number}"
  
    @shed_locations = Location
      .where("name LIKE ?", "%Shed #{shed_number}%")
      .includes(:makesheet)
      .group_by(&:row_label)
  
    @max_columns = @shed_locations.values.flatten.map(&:column_number).compact.max
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
  
    if params[:id].present?
      locations = [Location.find_by(id: params[:id])].compact
  
    elsif params[:trolley_start].present? && params[:trolley_end].present?
      start = params[:trolley_start].to_i
      finish = params[:trolley_end].to_i
      range = (start..finish)
  
      locations = Location.where(location_type: "Trolley")
                          .where(sort_order: range)
                          .order(:sort_order)
  
    elsif params[:shed].present? && params[:aisle_start].present? && params[:aisle_end].present?
      shed_number = params[:shed]
      shed_prefix = "Shed #{shed_number}"
      aisle_start = params[:aisle_start].to_i
      aisle_end   = params[:aisle_end].to_i
      side_start  = params[:side_start].presence || "Left"
      side_end    = params[:side_end].presence || "Right"
  
      # Ensure valid side range regardless of order
      sides = ["Left", "Right"]
      side_order = { "Left" => 0, "Right" => 1 }
      side_range = sides.select do |side|
        side_order[side] >= side_order[side_start] && side_order[side] <= side_order[side_end]
      end
  
      # Build match patterns like "%Shed 4 - Aisle 2 Right%"
      name_patterns = (aisle_start..aisle_end).flat_map do |aisle|
        side_range.map { |side| "%#{shed_prefix} - Aisle #{aisle} #{side}%" }
      end
  
      conditions = name_patterns.map { "name ILIKE ?" }.join(" OR ")
  
      locations = Location.where(location_type: "Aisle")
                          .where(conditions, *name_patterns)
                          .order(:sort_order)
  
    elsif params[:location_start].present? && params[:location_end].present?
      start_id = params[:location_start].to_i
      end_id   = params[:location_end].to_i
  
      start_location = Location.find_by(id: start_id, location_type: "Aisle")
      end_location   = Location.find_by(id: end_id, location_type: "Aisle")
  
      if start_location && end_location
        start_order = [start_location.sort_order, end_location.sort_order].min
        end_order   = [start_location.sort_order, end_location.sort_order].max
  
        locations = Location.where(location_type: "Aisle")
                            .where(sort_order: start_order..end_order)
                            .order(:sort_order)
      end
    end
  
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
  
      

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:name, :location_type, :sort_order, :active)
    end
end
