class VacuumPouchCalculatorController < ApplicationController

  # No model, nothing persisted — a standalone calculator page. Belongs to Cutting; exact
  # future use still undecided (may launch from a picksheet to calc a value for a
  # PicksheetItem, which Cutting already manages). Pegged to PicksheetItem's existing
  # :manage split (Office + Cutting) rather than inventing a new resource_key — revisit if
  # this tool ends up standalone and Office shouldn't see it.
  before_action :authorize_vacuum_pouch_calculator!

  # disables Turbo fallback stream behavior
  skip_forgery_protection if: -> { request.format.turbo_stream? }

  def new
    @pouch_options = Reference.where(group: 'vacuum_pouches')
  end

  def create
    @pouch_options = Reference.where(group: 'vacuum_pouches')
  
    if params[:pouch_id].blank?
      flash.now[:alert] = "Please select a pouch size."
      return render :new
    end
  
    begin
      pouch = Reference.find(params[:pouch_id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = "Invalid pouch selected."
      return render :new
    end
  
    item_count = params[:item_count].to_i
    total_weight = params[:total_weight].to_f
    pouch_weight = pouch.description.to_f
  
    packaging_weight = item_count * pouch_weight
    net_weight = total_weight - packaging_weight
  
    @result = {
      item_count: item_count,
      total_weight: total_weight,
      pouch_size: pouch.value,
      pouch_weight: pouch_weight,
      packaging_weight: packaging_weight,
      net_weight: net_weight
    }
  
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "calculator_result",
          partial: "vacuum_pouch_calculator/result",
          locals: { result: @result }
        )
      end
  
      format.html { render :new }
    end
  end

  private

  def authorize_vacuum_pouch_calculator!
    authorize! :manage, PicksheetItem
  end

end

