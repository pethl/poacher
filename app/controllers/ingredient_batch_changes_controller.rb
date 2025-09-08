# app/controllers/ingredient_batch_changes_controller.rb
class IngredientBatchChangesController < ApplicationController
  before_action :set_makesheet

  def new
    @items = dairy_ingredients
    @item  = params[:item].presence
  
    @recent_deliveries = []
    return unless @item.present?
  
    # currently linked on THIS makesheet?
    current_link = @makesheet.ingredient_batch_changes
                             .where(item: @item)
                             .order(changed_on: :desc, created_at: :desc)
                             .first
  
    scope = DeliveryInspection.for_item(@item).by_delivery_date_desc
    scope = scope.where.not(id: current_link.delivery_inspection_id) if current_link
    @recent_deliveries = scope.limit(3)
  end

 # app/controllers/ingredient_batch_changes_controller.rb
def create
  di = DeliveryInspection.find(params[:delivery_inspection_id])

  change = @makesheet.ingredient_batch_changes.build(
    delivery_inspection: di,
    item:       params[:item],
    changed_on: params[:changed_on],
    notes:      params[:notes]
  )

  if change.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "batch_change",
          partial: "ingredient_batch_changes/linked",
          locals: { makesheet: @makesheet, change: change }
        )
      end
      format.html do
        redirect_to edit_makesheet_path(@makesheet, anchor: "ingredients-section"),
          notice: "Linked #{di.item} batch #{di.batch_no}."
      end
    end
  else
    @items  = dairy_ingredients
    @item   = params[:item]
    @recent_deliveries = DeliveryInspection.last_three_for_item(@item)

    respond_to do |format|
      format.turbo_stream { render :new, status: :unprocessable_entity }
      format.html        { render :new, status: :unprocessable_entity }
    end
  end
end


  private
  def set_makesheet
    @makesheet = Makesheet.find(params[:makesheet_id])
  end
end


