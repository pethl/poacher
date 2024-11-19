class WasteRecordsController < ApplicationController
 # before_action :set_waste_record, only: %i[ show edit update destroy ]
  before_action :set_traceability_record

  # GET /waste_records or /waste_records.json
  def index
    @waste_records = WasteRecord.all
  end

  # GET /waste_records/1 or /waste_records/1.json
  def show
  end

  # GET /waste_records/new
  def new
  #  @waste_record = WasteRecord.new
    @waste_record = @traceability_record.waste_records.build
  end

  # GET /waste_records/1/edit
  def edit
  end

  # POST /waste_records or /waste_records.json
  def create
   # @waste_record = WasteRecord.new(waste_record_params)
    @waste_record = @traceability_record.waste_records.build(waste_record_params)


    respond_to do |format|
      if @waste_record.save
        format.html { redirect_to traceability_record_path(@traceability_record), notice: "Waste record was successfully created." }
        format.json { render :show, status: :created, location: @waste_record }
      else
        format.html {  render :new, status: :unprocessable_entity}
        format.json { render json: @waste_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waste_records/1 or /waste_records/1.json
  def update
    respond_to do |format|
      if @waste_record.update(waste_record_params)
        format.html { redirect_to @waste_record, notice: "Waste record was successfully updated." }
        format.json { render :show, status: :ok, location: @waste_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waste_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waste_records/1 or /waste_records/1.json
  def destroy
    @waste_record.destroy

    respond_to do |format|
      format.html { redirect_to waste_records_path, status: :see_other, notice: "Waste record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waste_record
      @waste_record = WasteRecord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def waste_record_params
      params.require(:waste_record).permit(:traceability_record_id, :waste_date, :wedges, :cooking, :blue, :t_and_bs, :waste)
    end

    def set_traceability_record
      @traceability_record = TraceabilityRecord.find(params[:traceability_record_id])
    end
end
