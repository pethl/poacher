class PalletisedDistributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_palletised_distribution, only: %i[show edit update destroy]

  def index
    @palletised_distributions = PalletisedDistribution.ordered
  end

  def show; end

  def new
    @palletised_distribution = PalletisedDistribution.new(
    date: Date.current
  )
  end

  def edit; end

  def create
    attrs = palletised_distribution_params

    if all_params_blank?(attrs)
      redirect_to palletised_distributions_path,
                  notice: "No data entered. Nothing was saved."
      return
    end

    @palletised_distribution = PalletisedDistribution.new(attrs)
    @palletised_distribution.user = current_user

    respond_to do |format|
      if @palletised_distribution.save
        format.html {
          redirect_to palletised_distributions_path,
                      notice: "Palletised distribution was successfully created."
        }

        format.json {
          render :show,
                 status: :created,
                 location: @palletised_distribution
        }
      else
        format.html {
          render :new,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @palletised_distribution.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @palletised_distribution.update(palletised_distribution_params)
        format.html {
          redirect_to palletised_distributions_path,
                      notice: "Palletised distribution was successfully updated."
        }

        format.json {
          render :show,
                 status: :ok,
                 location: @palletised_distribution
        }
      else
        format.html {
          render :edit,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @palletised_distribution.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @palletised_distribution.destroy

    respond_to do |format|
      format.html {
        redirect_to palletised_distributions_path,
                    status: :see_other,
                    notice: "Palletised distribution was successfully destroyed."
      }

      format.json { head :no_content }
    end
  end

  private

  def set_palletised_distribution
    @palletised_distribution = PalletisedDistribution.find(params[:id])
  end

  def all_params_blank?(attrs)
    attrs.values.all?(&:blank?)
  end

  def palletised_distribution_params
    params.require(:palletised_distribution).permit(
      :date,
      :company_name,
      :registration,
      :trailer_number_type,
      :temperature,
      :vehicle_clean,
      :destination,
      :number_of_pallets,
      :staff_signature,
      :driver_signature
    )
  end
end