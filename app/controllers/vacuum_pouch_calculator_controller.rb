class VacuumPouchCalculatorController < ApplicationController

  # disables Turbo fallback stream behavior
  skip_forgery_protection if: -> { request.format.turbo_stream? }

  def new
    @pouch_options = Reference.where(group: 'vacuum_pouches')
  end

  def create
    @pouch_options = Reference.where(group: 'vacuum_pouches')
    pouch = Reference.find(params[:pouch_id])
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

end

