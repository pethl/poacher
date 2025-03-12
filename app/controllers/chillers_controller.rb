class ChillersController < ApplicationController
  before_action :set_chiller, only: %i[ show edit update destroy ]

  #button on index to create a month of blank records at a time
  def create_month
    get_latest_date = Chiller.exists? ? Chiller.all.ordered.last.date : Date.today.beginning_of_month - 1.day
    i = 31
    
    while i >0
      puts i
      get_latest_date = get_latest_date+1.day
      @chiller = Chiller.new
      @chiller.date = get_latest_date
      @chiller.save
      i = i-1
      
    end
    redirect_to chillers_path, notice: "One months records have been added." 
  end

  # GET /chillers or /chillers.json
  def index
    if params[:month].present? && params[:year].present?
      @chillers = Chiller.filter_by_month_and_year(params[:month], params[:year])
    else
      #@chillers = Chiller.all
      @chillers = Chiller.where('date BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month).ordered
    end
  end

  # GET /chillers/1 or /chillers/1.json
  def show
  end

  # GET /chillers/new
  def new
    @chiller = Chiller.new
    @staffs = Staff.where(status: "Active").ordered
  end

  # GET /chillers/1/edit
  def edit
    @staffs = Staff.all.ordered
  end

  # POST /chillers or /chillers.json
  def create
    @chiller = Chiller.new(chiller_params)
    @staffs = Staff.where(status: "Active").ordered
     Rails.logger.debug "Params: #{params.inspect}"

    respond_to do |format|
      if @chiller.save
        format.html { redirect_to chillers_path, notice: "Chiller was successfully created." }
        format.json { render :show, status: :created, location: @chiller }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chiller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chillers/1 or /chillers/1.json
  def update
   
    @staffs = Staff.where(status: "Active").ordered
    respond_to do |format|
      if @chiller.update(chiller_params)
        format.html { redirect_to chillers_path, notice: "Chiller temperature record was successfully updated." }
        format.json { render :show, status: :ok, location: @chiller }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chiller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chillers/1 or /chillers/1.json
  def destroy
    @chiller.destroy

    respond_to do |format|
      format.html { redirect_to chillers_path, status: :see_other, notice: "Chiller was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chiller
      @chiller = Chiller.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chiller_params
      params.require(:chiller).permit(:date, :chiller_1, :chiller_2, :action_taken, :signature, :staff_id)
    end
end
