class BreakagesController < ApplicationController
  before_action :set_breakage, only: %i[ show edit update destroy ]

  def create_month
   
    if Breakage.all.count ==0   
      get_latest_date = Date.today.beginning_of_month-1.day
     else
       get_latest_date = Breakage.all.ordered.last.date
     end
    i = 31
    
    while i >0
      puts i
      get_latest_date = get_latest_date+1.day
      @chiller = Breakage.new
      @chiller.date = get_latest_date
      @chiller.save
      i = i-1
      
    end
    redirect_to breakages_path, notice: "One months records have been added." 
  end

  # GET /breakages or /breakages.json
  def index
    @breakages = Breakage.where('date BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today.end_of_month).ordered
  end

  # GET /breakages/1 or /breakages/1.json
  def show
  end

  # GET /breakages/new
  def new
    @breakage = Breakage.new
    @staffs = Staff.all.ordered
  end

  # GET /breakages/1/edit
  def edit
    @staffs = Staff.all.ordered
  end

  # POST /breakages or /breakages.json
  def create
    @breakage = Breakage.new(breakage_params)
    @staffs = Staff.all.ordered

    respond_to do |format|
      if @breakage.save
        format.html { redirect_to breakages_path, notice: "Breakage was successfully created." }
        format.json { render :show, status: :created, location: @breakage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @breakage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breakages/1 or /breakages/1.json
  def update
    respond_to do |format|
      if @breakage.update(breakage_params)
        @staffs = Staff.all.ordered
        format.html { redirect_to breakages_path, notice: "Breakage was successfully updated." }
        format.json { render :show, status: :ok, location: @breakage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @breakage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breakages/1 or /breakages/1.json
  def destroy
    @breakage.destroy

    respond_to do |format|
      format.html { redirect_to breakages_path, status: :see_other, notice: "Breakage was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_breakage
      @breakage = Breakage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def breakage_params
      params.require(:breakage).permit(:date, :breakage_occured, :knife, :cutting_board_cutting_wire, :ringing_machine_cutting_wire, :cutting_spring, :wire_broken_into_2, :wire_unwound, :other_number, :other_desc, :product_contaminated, :action_taken, :staff_id)
    end
end
