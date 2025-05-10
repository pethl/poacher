class MilkQualityMonitorsController < ApplicationController
  before_action :set_milk_quality_monitor, only: %i[ show edit update destroy ]

  # GET /milk_quality_monitors or /milk_quality_monitors.json
  def index
    @milk_quality_monitors = MilkQualityMonitor.all.ordered
  end

  # GET /milk_quality_monitors/1 or /milk_quality_monitors/1.json
  def show
  end

  # GET /milk_quality_monitors/new
  def new
    @milk_quality_monitor = MilkQualityMonitor.new
    @makesheets = Makesheet.not_finished
  end

  # GET /milk_quality_monitors/1/edit
  def edit
    @makesheets = Makesheet.not_finished
  end

  # POST /milk_quality_monitors or /milk_quality_monitors.json
  def create
    @milk_quality_monitor = MilkQualityMonitor.new(milk_quality_monitor_params)
    @makesheets = Makesheet.not_finished

    respond_to do |format|
      if @milk_quality_monitor.save
        format.html { redirect_to @milk_quality_monitor, notice: "Milk quality monitor was successfully created." }
        format.json { render :show, status: :created, location: @milk_quality_monitor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @milk_quality_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /milk_quality_monitors/1 or /milk_quality_monitors/1.json
  def update
    @makesheets = Makesheet.not_finished
    respond_to do |format|
      if @milk_quality_monitor.update(milk_quality_monitor_params)
        format.html { redirect_to milk_quality_monitors_path, notice: "Milk quality monitor was successfully updated." }
        format.json { render :show, status: :ok, location: @milk_quality_monitor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @milk_quality_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /milk_quality_monitors/1 or /milk_quality_monitors/1.json
  def destroy
    @milk_quality_monitor.destroy

    respond_to do |format|
      format.html { redirect_to milk_quality_monitors_path, status: :see_other, notice: "Milk quality monitor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      result = MilkQualityMonitor.import(params[:file])
      flash[:notice] = "Import complete: #{result[:added]} added, #{result[:skipped]} skipped."
    else
      flash[:alert] = "Please attach a CSV file."
    end
    redirect_to milk_quality_monitors_path
  end

  def rolling_geo_average
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_milk_quality_monitor
      @milk_quality_monitor = MilkQualityMonitor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def milk_quality_monitor_params
      params.require(:milk_quality_monitor).permit(:sample_date, :makesheet_id, :cell_count, :bactoscan, :butterfat, :lactose, :protein, :casein, :urea, :total_viable_colonies, :therms, :coliforms)
    end
end 
