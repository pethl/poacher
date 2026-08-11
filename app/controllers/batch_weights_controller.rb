class BatchWeightsController < ApplicationController
  before_action :set_batch_weight, only: %i[ show edit update destroy ]
  before_action :set_makesheets, only: %i[new create]

  # Admin/Mgmt only — not in the bounded-group matrix at all, so no other group ever
  # passes either check; kept as a read/manage split for consistency with the rest.
  before_action :authorize_batch_weight_read!, only: %i[index show waste_trend]
  before_action :authorize_batch_weight_manage!, only: %i[new create edit update destroy]

  # GET /batch_weights or /batch_weights.json
  def index
    @batch_weights = BatchWeight.all.ordered
  end

  def waste_trend
    @range_options = [3, 6, 9, 12]
    @months = params[:months].to_i
    @months = 12 unless @range_options.include?(@months)
    @make_types = Makesheet.where.not(make_type: [nil, ""]).distinct.order(:make_type).pluck(:make_type)
    @selected_make_type = params[:make_type].presence_in(@make_types)
    @end_date = Date.current
    @start_date = (@end_date - (@months - 1).months).beginning_of_month

    records = BatchWeight.waste_trend(
      start_date: @start_date,
      end_date: @end_date,
      make_type: @selected_make_type
    )

    @chart_series = build_waste_trend_series(records)
    @record_count = records.length
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
    def build_waste_trend_series(records)
      records.group_by { |record| record.makesheet.make_type }.sort.flat_map do |make_type, type_records|
        batch_points = type_records.map { |record| [record.date, record.waste_percentage] }
        monthly_averages = type_records.group_by { |record| record.date.beginning_of_month }
                                       .transform_values { |month_records| month_records.sum(&:waste_percentage) / month_records.length }
        rolling_points = monthly_averages.keys.sort.map do |month|
          window = monthly_averages.keys.select { |key| key.between?(month - 2.months, month) }
          [month, (window.sum { |key| monthly_averages.fetch(key) } / window.length).round(2)]
        end

        [
          {
            name: "#{make_type} batches",
            data: batch_points,
            dataset: { showLine: false, pointRadius: 4, pointHoverRadius: 6 }
          },
          {
            name: "#{make_type} 3-month rolling average",
            data: rolling_points,
            dataset: { borderWidth: 3, pointRadius: 2, tension: 0.2 }
          }
        ]
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_batch_weight
      @batch_weight = BatchWeight.find(params[:id])
    end

    def authorize_batch_weight_read!
      authorize! :read, @batch_weight || BatchWeight
    end

    def authorize_batch_weight_manage!
      authorize! :manage, @batch_weight || BatchWeight
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
