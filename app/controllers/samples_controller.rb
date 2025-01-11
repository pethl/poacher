class SamplesController < ApplicationController
  before_action :set_sample, only: %i[ show edit update destroy ]

  # GET /samples or /samples.json
  def index
   # @samples = Sample.all
    if params[:column].present?
      @samples = Sample.order("#{params[:column]} #{params[:direction]}")
    else
      @samples = Sample.all.ordered
    end
  end

  # GET /samples/1 or /samples/1.json
  def show
  end

  # GET /samples/new
  def new
    @sample = Sample.new
  end

  # GET /samples/1/edit
  def edit
    @makesheets = Makesheet.not_finished
  end

  # POST /samples or /samples.json
  def create
    @sample = Sample.new(sample_params)

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
    respond_to do |format|
      if @sample.update(sample_params)
        format.html { redirect_to @sample, notice: "Sample was successfully updated." }
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
    Sample.import(params[:file])
    redirect_to samples_path, notice: "New Sample records imported"  
  end

  def import_data(xlsx_path)
   # xlsx = Roo::Spreadsheet.open(path[:xlsx_path])
    xlsx = Roo::Spreadsheet.open('lib/data.xlsx')

   # data = Roo::Spreadsheet.open('lib/data.xlsx') # open spreadsheet
    xlsx.sheet(0).each_with_index(
      indicator: 'Indicator', 
      sample_no: 'Sample No.', 
      received_date: 'Received', 
      sample_description: 'Sample Description', 
      suite: 'Suite',
      classification: 'Classification',
      schedule: 'Schedule',
      barcode_count: 'Barcode Count',
      coagulase_positive_staphylococcus_37c_umqv9: 'Coagulase positive Staphylococcus 37°C (UMQV9) (cfu/g)',
      coagulase_positive_staphylococcus_37c_umqzw: 'Coagulase positive Staphylococcus 37°C (UMQZW) (cfu/g)',
      escherichia_coli_b_glucuronidase: 'Escherichia coli B-Glucuronidase+ (cfu/g)',
      listeria_species: 'Listeria Species (/25 g)',
      listeria_species_37: 'Listeria species 37°C (cfu/g)',
      presumptive_coliforms: 'Presumptive Coliforms 37°C (cfu/g)',
      salmonella: 'Salmonella (/25 g)',
      staphylococcus_aureus_enterotoxins: 'Staphylococcus aureus enterotoxins (/10  g)'
      ) do |row, row_index|
                                  
        next if row_index == 0 || Sample.find_by(sample_no: row[:sample_no]).present?

        Sample.create(
            indicator: row[:indicator],
            sample_no: row[:sample_no],
            received_date: row[:received_date],
            sample_description: row[:sample_description],
            suite: row[:suite],
            classification: row[:classification],
            schedule: row[:schedule],
            barcode_count: row[:barcode_count],
            coagulase_positive_staphylococcus_37c_umqv9: row[:coagulase_positive_staphylococcus_37c_umqv9],
            coagulase_positive_staphylococcus_37c_umqzw: row[:coagulase_positive_staphylococcus_37c_umqzw],
            escherichia_coli_b_glucuronidase: row[:escherichia_coli_b_glucuronidase],
            listeria_species: row[:listeria_species],
            listeria_species_37: row[:listeria_species_37],
            presumptive_coliforms: row[:presumptive_coliforms],
            salmonella: row[:salmonella],
            staphylococcus_aureus_enterotoxins: row[:staphylococcus_aureus_enterotoxins],

        )
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sample_params
      params.require(:sample).permit(:sample_no, :received_date, :sample_description, :makesheet_id, :suite, :classification, :schedule, :barcode_count, :coagulase_positive_staphylococcus_37c_umqv9, :coagulase_positive_staphylococcus_37c_umqzw, :escherichia_coli_b_glucuronidase, :Listeria_species, :Listeria_species_37, :presumptive_coliforms, :salmonella, :staphylococcus_aureus_enterotoxins)
    end
end
