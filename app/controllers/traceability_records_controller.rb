class TraceabilityRecordsController < ApplicationController
  before_action :set_traceability_record, only: %i[ show edit update destroy ]

  # GET /traceability_records or /traceability_records.json
  def index
    # only show records linked to open makesheets. makesheet is closed when sally adds to a batch weight record
    #@traceability_records = TraceabilityRecord.joins(:makesheet) .where.not(makesheets: { status: "Finished" })
   #instead where associated makesheet is not linked to a batch weight record.
   @traceability_records = TraceabilityRecord.joins(:makesheet)
                                            .left_joins(makesheet: :batch_weights)
                                            .where(batch_weights: { id: nil }) # Filters out Makesheets linked to BatchWeight


  if params[:column].present? && params[:direction].present?
    @traceability_records = @traceability_records.order("#{params[:column]} #{params[:direction]}")
  else
    @traceability_records = @traceability_records.order(created_at: :desc)
  end
  end

  # GET /traceability_records/1 or /traceability_records/1.json
  def show
    @waste_records = @traceability_record.waste_records.ordered
  end

  # GET /traceability_records/new
  def new
    @traceability_record = TraceabilityRecord.new
    # Exclude makesheets that are already associated with a TraceabilityRecord
    @makesheets = Makesheet.where.not(status: "Finished")
                           .where.not(id: TraceabilityRecord.pluck(:makesheet_id))
                           .ordered
  end
 
  # GET /traceability_records/1/edit
  def edit
    # Exclude makesheets that are already associated with a TraceabilityRecord
    @makesheets = Makesheet.where.not(status: "Finished")
                           .where.not(id: TraceabilityRecord.pluck(:makesheet_id))
                           .ordered
   
  end 

  # POST /traceability_records or /traceability_records.json
  def create
    @traceability_record = TraceabilityRecord.new(traceability_record_params)
   # Exclude makesheets that are already associated with a TraceabilityRecord
   @makesheets = Makesheet.where.not(status: "Finished")
   .where.not(id: TraceabilityRecord.pluck(:makesheet_id))
   .ordered

    respond_to do |format|
      if @traceability_record.save
        format.html { redirect_to @traceability_record, notice: "Traceability record was successfully created." }
        format.json { render :show, status: :created, location: @traceability_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @traceability_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /traceability_records/1 or /traceability_records/1.json
  def update
    respond_to do |format|
      if @traceability_record.update(traceability_record_params)
        format.html { redirect_to @traceability_record, notice: "Traceability record was successfully updated." }
        format.json { render :show, status: :ok, location: @traceability_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @traceability_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /traceability_records/1 or /traceability_records/1.json
  def destroy
    @traceability_record.destroy

    respond_to do |format|
      format.html { redirect_to traceability_records_path, status: :see_other, notice: "Traceability record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_traceability_record
      @traceability_record = TraceabilityRecord.find(params[:id])
      
    end

    # Only allow a list of trusted parameters through.
    def traceability_record_params
      params.require(:traceability_record).permit(:makesheet_id, :date_started_batch, :date_finished_batch, :total_weight_of_batch,:confirmed_number_of_cheeses, :all_rinds_visually_clean, :individual_cheese_weight_1, :individual_cheese_weight_2, :individual_cheese_weight_3, :individual_cheese_weight_4, :individual_cheese_weight_5, :individual_cheese_weight_6, :individual_cheese_weight_7, :individual_cheese_weight_8, :individual_cheese_weight_9, :individual_cheese_weight_10, :individual_cheese_weight_11, :individual_cheese_weight_12, :individual_cheese_weight_13, :individual_cheese_weight_14, :individual_cheese_weight_15, :individual_cheese_weight_16, :individual_cheese_weight_17, :individual_cheese_weight_18, :individual_cheese_weight_19, :individual_cheese_weight_20, :individual_cheese_weight_21, :individual_cheese_weight_22, :individual_cheese_weight_23, :individual_cheese_weight_24, :individual_cheese_weight_25, :individual_cheese_weight_26, :individual_cheese_weight_27, :individual_cheese_weight_28, :individual_cheese_weight_29, :individual_cheese_weight_30, :individual_cheese_weight_31, :individual_cheese_weight_32, :individual_cheese_weight_33, :individual_cheese_weight_34, :individual_cheese_weight_35) 
    end
end
