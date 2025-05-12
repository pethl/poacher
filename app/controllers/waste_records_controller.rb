class WasteRecordsController < ApplicationController
  before_action :set_traceability_record
  before_action :set_waste_record, only: %i[edit update destroy]

  # GET /waste_records
  def index
    @waste_records = WasteRecord.all
  end

  # GET /waste_records/new
  def new
    @waste_record = @traceability_record.waste_records.build
  end

  # GET /waste_records/1/edit
  def edit
    # @waste_record is already set by before_action
  end

  # POST /waste_records
  def create
    @waste_record = @traceability_record.waste_records.build(waste_record_params)

    respond_to do |format|
      if @waste_record.save
        format.html { redirect_to @traceability_record, notice: "Waste record was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waste_records/1
  def update
    respond_to do |format|
      if @waste_record.update(waste_record_params)
        format.html { redirect_to @traceability_record, notice: "Waste record was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waste_records/1
  def destroy
    @waste_record.destroy
    respond_to do |format|
      format.html { redirect_to @traceability_record, notice: "Waste record was successfully destroyed." }
    end
  end

  private

    def set_traceability_record
      @traceability_record = TraceabilityRecord.find(params[:traceability_record_id])
    end

    def set_waste_record
      @waste_record = @traceability_record.waste_records.find(params[:id])
    end

    def waste_record_params
      params.require(:waste_record).permit(:waste_date, :wedges, :cooking, :blue, :t_and_bs, :waste)
    end
end
