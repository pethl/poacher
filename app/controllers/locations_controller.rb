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

    shed_param       = params[:shed].presence || "4"        # Default to Shed 4
    alley_start      = params[:alley_start].to_i
    alley_end        = params[:alley_end].to_i
    side_start_param = params[:side_start].presence || "Left"
    side_end_param   = params[:side_end].presence || "Right"

    if params[:id].present?
      @locations = [Location.find(params[:id])]
  
    elsif params[:trolley_start].present? && params[:trolley_end].present?
      start = params[:trolley_start].to_i
      finish = params[:trolley_end].to_i
      range = (start..finish)
  
      @locations = Location.where(location_type: "Trolley")
                           .where(sort_order: range)
                           .order(:sort_order)
  
    elsif params[:shed].present? && params[:alley_start].present? && params[:alley_end].present?
      shed = "Shed #{params[:shed]}"
      alley_range = (params[:alley_start].to_i)..(params[:alley_end].to_i)
    
      side_start = params[:side_start].presence || "Left"
      side_end   = params[:side_end].presence || "Right"
    
      side_range = [side_start, side_end]
    
      # Generate all possible location strings (Alley X Side) within the given range
      queries = alley_range.flat_map do |alley|
        side_range.map { |side| "Alley #{alley} #{side}" }
      end
    
      query_regex = queries.join("|")
    
      @locations = Location.where(location_type: "Shed")
                            .where("name LIKE ?", "%#{shed}%")
                            .where("name ~* ?", query_regex)
                            .order(:sort_order)
                          
  
      shed = "Shed #{params[:shed]}"
      side = params[:side]
      alley_range = (params[:alley_start].to_i)..(params[:alley_end].to_i)
  
      query = alley_range.map { |a| "Alley #{a} #{side}" }.join("|")
  
      @locations = Location.where(location_type: "Shed")
                           .where("name LIKE ?", "%#{shed}%")
                           .where("name ~* ?", query)
                           .order(:sort_order)
  
    else
      @locations = []
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
