class PicksheetItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_picksheet
  before_action :set_picksheet_item, only: %i[edit update destroy]
  before_action :set_contact_ids, only: %i[new edit create update]
  before_action :prepare_form_collections, only: [:new, :create, :edit, :update]

  # NEW (inline in a frame)
  def new
    @picksheet_item = @picksheet.picksheet_items.build
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet.contact_id)
    render layout: false if turbo_frame_request?
  end

  # EDIT (inline in a frame)
  def edit
    @picksheet = Picksheet.find(params[:picksheet_id])
    @picksheet_item = @picksheet.picksheet_items.find(params[:id])
  
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          @picksheet_item, # uses dom_id(@picksheet_item)
          partial: "picksheet_items/row_form",
          locals: { picksheet: @picksheet, picksheet_item: @picksheet_item }
        )
      end
      # Optional HTML fallback so direct visits don't error:
      format.html { redirect_to picksheet_path(@picksheet) }
    end
  end
  
  
  def show
    @picksheet = Picksheet.find(params[:picksheet_id])
    @picksheet_item = @picksheet.picksheet_items.find(params[:id])
  
    respond_to do |format|
      format.turbo_stream # will use show.turbo_stream.erb
      format.html { redirect_to picksheet_path(@picksheet) }
    end
  end
  

  # CREATE
  def create
    @picksheet_item = @picksheet.picksheet_items.build(picksheet_item_params)
  
    # keep virtual wedge_size available for re-render if needed
    @picksheet_item.wedge_size = params.dig(:picksheet_item, :wedge_size)
  
    # If you rely on these in the form, make sure these are set before rendering
    # (assuming you already run before_actions like set_contact_ids / prepare_form_collections)
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet.contact_id) if @contact_ids.include?(@picksheet.contact_id)
  
    if @picksheet_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(
              "picksheet_items",
              partial: "picksheet_items/picksheet_item",
              locals: { picksheet_item: @picksheet_item }
            ),
            turbo_stream.update(helpers.dom_id(PicksheetItem.new), "")
          ]
        end
        format.html { redirect_to picksheet_url(@picksheet), notice: "Line Item was successfully created." }
      end
    else
      # Re-render the inline form (with errors) into the "new item" frame
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(PicksheetItem.new),
            partial: "picksheet_items/form_new",
            locals: {
              picksheet: @picksheet,
              picksheet_item: @picksheet_item,
              sale_product: @sale_product,
              sale_product_butter: @sale_product_butter,
              sale_product_other: @sale_product_other,
              cut_guest_cheeses: @cut_guest_cheeses,
              cheese_accompaniments: @cheese_accompaniments,
              sale_size: @sale_size,
              wedges_sizes: @wedges_sizes,
              sale_pricing: @sale_pricing,
              contact_ids: @contact_ids,
              checkbox_class: @checkbox_class,
              field_class_flex_med: @field_class_flex_med
            }
          ), status: :unprocessable_entity
        end
  
        # Fallback for non-Turbo requests: render the show page that contains the inline frame
        format.html do
          flash.now[:alert] = "Please fix the errors below."
          render "picksheets/show", status: :unprocessable_entity
        end
      end
    end
  end
  

  # UPDATE
  def update
    @picksheet = Picksheet.find(params[:picksheet_id])
    @picksheet_item = @picksheet.picksheet_items.find(params[:id])
  
    if @picksheet_item.update(picksheet_item_params)
      respond_to do |format|
        format.turbo_stream # uses update.turbo_stream.erb you already have
        format.html { redirect_to @picksheet, notice: "Line item updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @picksheet_item,
            partial: "picksheet_items/row_form",
            locals: { picksheet: @picksheet, picksheet_item: @picksheet_item }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  

  # DESTROY
  def destroy
    @picksheet_item.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@picksheet_item) }
      format.html { redirect_to picksheet_path(@picksheet), notice: "Line item was successfully destroyed." }
    end
  end

  private

  def set_picksheet
    @picksheet = Picksheet.find(params[:picksheet_id])
  end

  def set_picksheet_item
    @picksheet_item = @picksheet.picksheet_items.find(params[:id])
  end

  # Build canonical product + size from your multiple inputs
  def picksheet_item_params
    raw = params.require(:picksheet_item).permit(
      :product, :product_radio, :product_other, :product_butter, :product_cut_guest, :product_cheese_accompaniments,
      :picksheet_id, :makesheet_id, :size, :wedge_size, :pricing, :count, :custom_notes,
      :weight, :code, :sp_price, :bb_date
    )

    selected_product =
      raw[:product_radio].presence ||
      raw[:product_other].presence ||
      raw[:product_butter].presence ||
      raw[:product_cut_guest].presence ||
      raw[:product_cheese_accompaniments].presence

    selected_size = raw[:wedge_size].presence || raw[:size]

    raw.except(
      :product_radio, :product_other, :product_butter, :product_cut_guest, :product_cheese_accompaniments, :wedge_size, :size
    ).merge(
      product: selected_product,
      size: selected_size
    )
  end

  def set_contact_ids
    @contact_ids = Makesheet.not_finished.distinct.pluck(:contact_id).compact
  end

  def prepare_form_collections
    # however you currently build these for "new"
    @contact_ids = Makesheet.not_finished.distinct.pluck(:contact_id)
    @makesheets  = Makesheet.not_finished.where(contact_id: @picksheet.contact_id) if @contact_ids.include?(@picksheet.contact_id)
  
    # if these are helpers already, skip; else set ivars or helpers so the views/partials see them
    @sale_product         = Reference.where(group: "sale_product", active: true).pluck(:value)
    @sale_product_butter  = Reference.where(group: "sale_product_butter", active: true).pluck(:value)
    @sale_product_other   = Reference.where(group: "sale_product_other", active: true).pluck(:value)
    @cut_guest_cheeses    = Reference.where(group: "cut_guest_cheeses", active: true).pluck(:value)
    @cheese_accompaniments= Reference.where(group: "cheese_accompaniments", active: true).pluck(:value)
    @sale_size            = Reference.where(group: "sale_size", active: true).pluck(:value)
    @wedges_sizes         = Reference.where(group: "wedges_sizes", active: true).pluck(:value)
    @sale_pricing         = Reference.where(group: "sale_pricing", active: true).pluck(:value)
  end
end
