class SamplesController < ApplicationController
  before_action :set_sample, only: %i[ show edit update destroy ]

  # GET /samples or /samples.json
  def index
    @filter = params[:filter]
  
    @samples = Sample.all
  
    if @filter.present? && @filter != 'All'
      if %w[Mature Young].include?(@filter)
        # Starts with filter for "Mature" and "Young"
        @samples = @samples.where("sample_description ILIKE ?", "#{@filter}%")
      else
        # Standard contains for others like "Butter", "Raw Milk"
        @samples = @samples.where("sample_description ILIKE ?", "%#{@filter}%")
      end
    end
  
    if params[:column].present?
      @samples = @samples.order("#{params[:column]} #{params[:direction]}")
    else
      @samples = @samples.ordered
    end
  
    @samples = @samples.includes(:makesheets)
  
    @filters = ['All', 'Young', 'Mature', 'Butter', 'Raw Milk']
  end
  
  

  # GET /samples/1 or /samples/1.json
  def show
  end

  # GET /samples/new
  def new
    @sample = Sample.new
   @active_makesheets = Makesheet.not_finished.ordered_reverse
  end

  # GET /samples/1/edit
  def edit
   @active_makesheets = Makesheet.not_finished.ordered_reverse
  end

  # POST /samples or /samples.json
  def create
    @sample = Sample.new(sample_params)
   @active_makesheets = Makesheet.not_finished.ordered_reverse

    respond_to do |format|
      if @sample.save
        format.html { redirect_to @sample, notice: "Sample was successfully created." }
        format.json { render :show, status: :created, location: @sample }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /samples/1 or /samples/1.json
  def update
   @active_makesheets = Makesheet.not_finished.ordered_reverse
    respond_to do |format|
      if @sample.update(sample_params)
        format.html { redirect_to samples_path, notice: "Sample was successfully updated." }
        format.json { render :show, status: :ok, location: @sample }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1 or /samples/1.json
  def destroy
    @sample.destroy

    respond_to do |format|
      format.html { redirect_to samples_path, status: :see_other, notice: "Sample was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    upload = params[:file]
  
    unless upload.present?
      redirect_to samples_path, alert: "Please select a file." and return
    end
  
    if upload.is_a?(Array)
      upload = upload.first
    end
  
    unless upload.respond_to?(:original_filename)
      redirect_to samples_path, alert: "Something went wrong. Invalid file." and return
    end
  
    result = Sample.import(upload)
  
    message = "Imported #{result[:imported_count]} samples."
    message += " Rejected #{result[:rejected_count]} duplicates." if result[:rejected_count].positive?
  
    redirect_to samples_path, notice: message
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sample_params
      params.require(:sample).permit(
        :indicator,
        :sample_no,
        :received_date,
        :sample_description,
        :suite,
        :classification,
        :schedule,
        :barcode_count,
        :coagulase_positive_staphylococcus_37c_umqv9,
        :coagulase_positive_staphylococcus_37c_umqzw,
        :escherichia_coli_b_glucuronidase,
        :listeria_species,
        :listeria_species_37,
        :presumptive_coliforms,
        :salmonella,
        :staphylococcus_aureus_enterotoxins,
        :aerobic_plate_count_22c_3_days,
        :aerobic_plate_count_30c,
        :aerobic_plate_count_37c_2_days,
        :ash,
        :campylobacter_species_10g,
        :campylobacter_species_25g,
        :carbohydrates,
        :crude_protein,
        :energy_kcal,
        :energy_kj,
        :escherichia_coli_100ml,
        :escherichia_coli_o157,
        :fructose,
        :galactose,
        :glucose,
        :histamine,
        :identification_listeria_species_1,
        :lactose,
        :listeria_species_swab,
        :listeria_species_confirmation_maldi,
        :maltose,
        :moisture,
        :monounsaturated_fatty_acids,
        :ph,
        :polyunsaturated_fatty_acids,
        :presumptive_coliforms_swab,
        :presumptive_enterobacteriaceae,
        :salt,
        :saturated_fatty_acids,
        :sodium,
        :sucrose,
        :total_coliforms_100ml,
        :total_dietary_fibre,
        :total_fat,
        :total_sugars,
        :trans_fatty_acids_per_fat,
        :trans_fatty_acids,
        :water_activity
      )
    end
end
