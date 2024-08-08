class PicksheetItemsController < ApplicationController
  before_action :set_picksheet_item, only: %i[ show edit update destroy ]

  # GET /picksheet_items or /picksheet_items.json
  def index
    @picksheet_items = PicksheetItem.all
  end

  # GET /picksheet_items/1 or /picksheet_items/1.json
  def show
  end

  # GET /picksheet_items/new
  def new
    @picksheet_item = PicksheetItem.new
  end

  # GET /picksheet_items/1/edit
  def edit
  end

  # POST /picksheet_items or /picksheet_items.json
  def create
    @picksheet_item = PicksheetItem.new(picksheet_item_params)

    respond_to do |format|
      if @picksheet_item.save
        format.html { redirect_to picksheet_item_url(@picksheet_item), notice: "Picksheet item was successfully created." }
        format.json { render :show, status: :created, location: @picksheet_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picksheet_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /picksheet_items/1 or /picksheet_items/1.json
  def update
    respond_to do |format|
      if @picksheet_item.update(picksheet_item_params)
        format.html { redirect_to picksheet_item_url(@picksheet_item), notice: "Picksheet item was successfully updated." }
        format.json { render :show, status: :ok, location: @picksheet_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picksheet_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /picksheet_items/1 or /picksheet_items/1.json
  def destroy
    @picksheet_item.destroy

    respond_to do |format|
      format.html { redirect_to picksheet_items_url, notice: "Picksheet item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picksheet_item
      @picksheet_item = PicksheetItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def picksheet_item_params
      params.require(:picksheet_item).permit(:product, :size, :count, :weight, :code, :sp_price, :bb_date)
    end
end
