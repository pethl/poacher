class PicksheetsController < ApplicationController
  before_action :set_picksheet, only: %i[ show edit update destroy ]

  # GET /picksheets or /picksheets.json
  def sales_home
    @picksheets = Picksheet.all.order(:date_order_placed)
  end
  
  # GET /picksheets or /picksheets.json
  def index
    @picksheets = Picksheet.all
  end

  # GET /picksheets/1 or /picksheets/1.json
  def show
  end

  # GET /picksheets/new
  def new
    @picksheet = Picksheet.new
  end

  # GET /picksheets/1/edit
  def edit
  end

  # POST /picksheets or /picksheets.json
  def create
    @picksheet = Picksheet.new(picksheet_params)

    respond_to do |format|
      if @picksheet.save
        format.html { redirect_to picksheet_url(@picksheet), notice: "Picksheet was successfully created." }
        format.json { render :show, status: :created, location: @picksheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picksheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /picksheets/1 or /picksheets/1.json
  def update
    respond_to do |format|
      if @picksheet.update(picksheet_params)
        format.html { redirect_to picksheet_url(@picksheet), notice: "Picksheet was successfully updated." }
        format.json { render :show, status: :ok, location: @picksheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picksheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /picksheets/1 or /picksheets/1.json
  def destroy
    @picksheet.destroy

    respond_to do |format|
      format.html { redirect_to picksheets_url, notice: "Picksheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picksheet
      @picksheet = Picksheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def picksheet_params
      params.require(:picksheet).permit(:date_order_placed, :delivery_required_by, :order_number, :contact_telephone_number, :invoice_number, :carrier, :carrier_delivery_date, :number_of_boxes)
    end
end
