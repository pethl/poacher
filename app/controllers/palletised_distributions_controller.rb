class PalletisedDistributionsController < ApplicationController
  before_action :set_palletised_distribution, only: %i[show edit update destroy]
  before_action :set_staffs, only: %i[new edit create update]

  # GET /palletised_distributions
  def index
    @palletised_distributions = PalletisedDistribution.all
  end

  # GET /palletised_distributions/1
  def show; end

  # GET /palletised_distributions/new
  def new
    @palletised_distribution = PalletisedDistribution.new
  end

  # GET /palletised_distributions/1/edit
  def edit; end

  # POST /palletised_distributions
  def create
    @palletised_distribution = PalletisedDistribution.new(palletised_distribution_params)

    # short-circuit when the user submitted an empty form
    if all_params_blank?(palletised_distribution_params)
      redirect_to palletised_distributions_path, notice: "No data entered. Nothing was saved."
      return
    end

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

  # PATCH/PUT /palletised_distributions/1
  def update
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

  # DELETE /palletised_distributions/1
  def destroy
    @palletised_distribution.destroy
    respond_to do |format|
      format.html { redirect_to palletised_distributions_path, status: :see_other, notice: "Palletised distribution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_palletised_distribution
    @palletised_distribution = PalletisedDistribution.find(params[:id])
  end

  # Single source of truth for staff list
  def set_staffs
    # keep your existing scopes if you have them
    @staffs = Staff.where(employment_status: "Active").ordered
  end

  # Treat a fully blank submission as "nothing entered"
  def all_params_blank?(attrs)
    attrs.values.all?(&:blank?)
  end

  def palletised_distribution_params
    params.require(:palletised_distribution).permit(
      :date, :company_name, :registration, :trailer_number_type, :temperature,
      :vehicle_clean, :destination, :number_of_pallets, :staff_id,
      :staff_signature, :driver_signature
    )
  end
end
