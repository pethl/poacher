class PicksheetItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_picksheet
  before_action :set_picksheet_item, only: %i[show edit update destroy]  
  before_action :prepare_customer_makesheets, only: %i[new edit create update]
  before_action :prepare_form_collections, only: %i[new edit create update]

  # Office: manage · Cutting: manage. Both groups manage this one, so read vs manage
  # doesn't actually gate anyone out here — kept for consistency with the rest.
  before_action :authorize_picksheet_item_read!, only: %i[show]
  before_action :authorize_picksheet_item_manage!, only: %i[new edit create update destroy]

  # NEW (inline in a frame)
  def new
    @picksheet_item = @picksheet.picksheet_items.build
    render layout: false if turbo_frame_request?
  end

  # EDIT (inline in a frame)
  def edit

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

    if @picksheet_item.save
      respond_to do |format|
        format.turbo_stream do
          # If you already have create.turbo_stream.erb, this will render that.
          # Otherwise, this inline fallback appends the row and clears the “new” frame.
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
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(PicksheetItem.new),
            partial: "picksheet_items/row_form",
            locals: {
              picksheet: @picksheet,
              picksheet_item: @picksheet_item
            }
          ), status: :unprocessable_entity
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # UPDATE
  def update
   
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

  def authorize_picksheet_item_read!
    authorize! :read, @picksheet_item || PicksheetItem
  end

  def authorize_picksheet_item_manage!
    authorize! :manage, @picksheet_item || PicksheetItem
  end

  # Build canonical product + size from your multiple inputs
  def picksheet_item_params
    raw = params.require(:picksheet_item).permit(
      :product_radio, :product_other, :product_butter, :product_cut_guest, :product_cheese_accompaniments,
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

  def prepare_customer_makesheets
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet.contact_id)
  end

  def prepare_form_collections
   
    @sale_product          = Reference.values_for("sale_product")
    @sale_product_butter   = Reference.values_for("sale_product_butter")
    @sale_product_other    = Reference.values_for("sale_product_other")
    @cut_guest_cheeses     = Reference.values_for("cut_guest_cheeses")
    @cheese_accompaniments = Reference.values_for("cheese_accompaniments")
    @sale_size             = Reference.values_for("sale_size")
    @wedges_sizes          = Reference.values_for("wedges_sizes")
    @sale_pricing          = Reference.values_for("sale_pricing")
  end
end
