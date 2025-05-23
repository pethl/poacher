class BatchWeightsController < ApplicationController
  before_action :set_batch_weight, only: %i[ show edit update destroy ]
  before_action :set_makesheets, only: %i[new create]


  # GET /batch_weights or /batch_weights.json
  def index
    @batch_weights = BatchWeight.all.ordered
  end
 
  # GET /batch_weights/1 or /batch_weights/1.json
  def show
  end

  # GET /batch_weights/new
  def new
    @batch_weight = BatchWeight.new
    
  end

  # GET /batch_weights/1/edit
  def edit
   
  end

  # POST /batch_weights or /batch_weights.json
  def create
    @batch_weight = BatchWeight.new(batch_weight_params)
    @makesheets = Makesheet.not_finished

    respond_to do |format|
      if @batch_weight.save
        format.html { redirect_to batch_weights_path, notice: "Batch weight was successfully created." }
        format.json { render :show, status: :created, location: @batch_weight }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch_weight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batch_weights/1 or /batch_weights/1.json
  def update
   
    respond_to do |format|
      if @batch_weight.update(batch_weight_params)
        format.html { redirect_to batch_weights_path, notice: "Batch weight was successfully updated." }
        format.json { render :show, status: :ok, location: @batch_weight }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch_weight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batch_weights/1 or /batch_weights/1.json
  def destroy
    @batch_weight.destroy

    respond_to do |format|
      format.html { redirect_to batch_weights_path, status: :see_other, notice: "Batch weight was successfully destroyed." }
      format.json { head :no_content }
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_weight
      @batch_weight = BatchWeight.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_weight_params
      params.require(:batch_weight).permit(:date, :makesheet_id, :washed_batch_weight, :total_waste, :all_rinds_visually_clean, :comments)
    end

    def set_makesheets
      # Get all makesheets that are linked to a TraceabilityRecord
      makesheets_with_traceability = Makesheet.joins(:traceability_records).distinct
  
      # Exclude makesheets that are already linked to a BatchWeight record
      @makesheets = makesheets_with_traceability.left_joins(:batch_weights)
                                                 .where(batch_weights: { id: nil })
    end
end
