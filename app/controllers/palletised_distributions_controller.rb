class PalletisedDistributionsController < ApplicationController
  before_action :set_palletised_distribution, only: %i[ show edit update destroy ]

  # GET /palletised_distributions or /palletised_distributions.json
  def index
    @palletised_distributions = PalletisedDistribution.all
  end

  # GET /palletised_distributions/1 or /palletised_distributions/1.json
  def show
  end

  # GET /palletised_distributions/new
  def new
    @palletised_distribution = PalletisedDistribution.new
    @staffs = Staff.all.ordered
  end

  # GET /palletised_distributions/1/edit
  def edit
    @staffs = Staff.all.ordered
  end

  # POST /palletised_distributions or /palletised_distributions.json
  def create
    @staffs = Staff.all.ordered
    @palletised_distribution = PalletisedDistribution.new(palletised_distribution_params)

    respond_to do |format|
      if @palletised_distribution.save
        format.html { redirect_to palletised_distributions_path, notice: "Palletised distribution was successfully created." }
        format.json { render :show, status: :created, location: @palletised_distribution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @palletised_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /palletised_distributions/1 or /palletised_distributions/1.json
  def update
    @staffs = Staff.all.ordered
    respond_to do |format|
      if @palletised_distribution.update(palletised_distribution_params)
        format.html { redirect_to palletised_distributions_path, notice: "Palletised distribution was successfully updated." }
        format.json { render :show, status: :ok, location: @palletised_distribution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @palletised_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /palletised_distributions/1 or /palletised_distributions/1.json
  def destroy
    @palletised_distribution.destroy

    respond_to do |format|
      format.html { redirect_to palletised_distributions_path, status: :see_other, notice: "Palletised distribution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_palletised_distribution
      @palletised_distribution = PalletisedDistribution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def palletised_distribution_params
      params.require(:palletised_distribution).permit(:date, :company_name, :registration, :trailer_number_type, :temperature, :vehicle_clean, :destination, :number_of_pallets, :staff_id, :drivers_signature)
    end
end
