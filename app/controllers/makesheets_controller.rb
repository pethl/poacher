class MakesheetsController < ApplicationController
  before_action :set_makesheet, only: %i[ show edit update destroy ]

  # customer page for Dairy logon Start
  def dairy_home
    @makesheets = Makesheet.order('make_date DESC')
  #  @makesheets = @makesheets.last(7)
  end
  
  # GET /makesheets or /makesheets.json
  def index
    @makesheets = Makesheet.all.order(:make_date)
  end

  # GET /makesheets/1 or /makesheets/1.json
  def show
  end

  # GET /makesheets/new
  def new
    @makesheet = Makesheet.new
  end

  # GET /makesheets/1/edit
  def edit
  end

  # POST /makesheets or /makesheets.json
  def create
    @makesheet = Makesheet.new(makesheet_params)

    respond_to do |format|
      if @makesheet.save
        format.html { redirect_to makesheet_url(@makesheet), notice: "Makesheet was successfully created." }
        format.json { render :show, status: :created, location: @makesheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @makesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /makesheets/1 or /makesheets/1.json
  def update
    respond_to do |format|
      if @makesheet.update(makesheet_params)
        format.html { redirect_to makesheet_url(@makesheet), notice: "Makesheet was successfully updated." }
        format.json { render :show, status: :ok, location: @makesheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @makesheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /makesheets/1 or /makesheets/1.json
  def destroy
    @makesheet.destroy

    respond_to do |format|
      format.html { redirect_to makesheets_url, notice: "Makesheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_makesheet
      @makesheet = Makesheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def makesheet_params
      params.require(:makesheet).permit(:make_date, :milk_used, :total_weight, :number_of_cheeses, :grade, :weight_type)
    end
end
