class SamplesController < ApplicationController
  before_action :set_sample, only: %i[ show edit update destroy ]

  # GET /samples or /samples.json
  def index
    if params[:column].present?
      @samples = Sample.includes(:makesheets).order("#{params[:column]} #{params[:direction]}")
    else
      @samples = Sample.includes(:makesheets).ordered
    end
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
    file = params[:file]

    # Debugging line
  Rails.logger.debug "File param: #{file.inspect}"
  
    unless file
      redirect_to samples_path, alert: "Please select a file first." and return
    end

     # If file is an Array, grab the first element
  file = file.first if file.is_a?(Array)
  
    unless [".csv", ".xlsx", ".xls"].include?(File.extname(file.original_filename).downcase)
      redirect_to samples_path, alert: "Invalid file type. Please upload a CSV or Excel file." and return
    end

  
    result = Sample.import(file)
  
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
      params.require(:sample).permit(:indicator, :sample_no, :received_date, :sample_description, :makesheet_id, :suite, :classification, :schedule, :barcode_count, :coagulase_positive_staphylococcus_37c_umqv9, :coagulase_positive_staphylococcus_37c_umqzw, :escherichia_coli_b_glucuronidase, :Listeria_species, :Listeria_species_37, :presumptive_coliforms, :salmonella, :staphylococcus_aureus_enterotoxins, makesheet_ids: [])
    end
end
