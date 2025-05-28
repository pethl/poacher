class PicksheetItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_picksheet
  before_action :set_picksheet_item, only: %i[ edit update destroy ]
  before_action :set_contact_ids, only: %i[ new edit update create ]
  

  # GET /picksheet_items or /picksheet_items.json
  def index
    @picksheet_items = PicksheetItem.all
  end

  # GET /picksheet_items/1 or /picksheet_items/1.json
  def show
  end

  # GET /picksheet_items/new
  def new
    @picksheet_item = @picksheet.picksheet_items.build
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet_item.picksheet.contact_id)
  end

  # GET /picksheet_items/1/edit
  def edit
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet_item.picksheet.contact_id)
  end

  # POST /picksheet_items or /picksheet_items.json
  def create
    @picksheet_item = @picksheet.picksheet_items.build(picksheet_item_params)

    if @contact_ids.include?(@picksheet_item.picksheet.contact_id)
     @makesheets = Makesheet.not_finished.where(contact_id: @picksheet_item.picksheet.contact_id)
    end 
    
  if @picksheet_item.save
    respond_to do |format|
        format.html { redirect_to picksheet_url(@picksheet), notice: "Line Item was successfully created." }
        format.turbo_stream 
      end
      else
        render :new, status: :unprocessable_entity
      end
    end
  

  # PATCH/PUT /picksheet_items/1 or /picksheet_items/1.json
  def update
    @makesheets = Makesheet.not_finished.where(contact_id: @picksheet_item.picksheet.contact_id)
    if @picksheet_item.update(picksheet_item_params)
      respond_to do |format|
        format.html { redirect_to picksheet_path(@picksheet), notice: "Line item was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Line Item was successfully updated." }
     end
    else
          render :edit, status: :unprocessable_entity
      end
    end

  # DELETE /picksheet_items/1 or /picksheet_items/1.json
  def destroy
    @picksheet_item.destroy

    respond_to do |format|
        format.html { redirect_to picksheet_path(@picksheet), notice: "Line item was successfully destroyed." }
        format.turbo_stream { flash.now[:notice] = "Line item was successfully destroyed." }
      end
   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picksheet_item
      @picksheet_item = @picksheet.picksheet_items.find(params[:id])
    end
    
    def set_picksheet
       @picksheet = Picksheet.find(params[:picksheet_id])
    end

    # Only allow a list of trusted parameters through.
    def picksheet_item_params
      raw = params.require(:picksheet_item)
    
      selected_product =
        raw[:product_radio].presence ||
        raw[:product_other].presence ||
        raw[:product_butter].presence
    
      # Permit only real attributes — do NOT include the virtual ones
      raw.permit(:picksheet_id,
                 :makesheet_id,
                 :size,
                 :wedge_size,
                 :pricing,
                 :count,
                 :custom_notes,
                 :weight,
                 :code,
                 :sp_price,
                 :bb_date)
         .merge(product: selected_product)
    end

    def set_contact_ids
      @contact_ids = Makesheet.where.not(status: "Finished").pluck(:contact_id).compact.uniq
    end
end
