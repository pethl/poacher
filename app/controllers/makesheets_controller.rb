class MakesheetsController < ApplicationController
  before_action :set_makesheet, only: %i[ show edit update destroy batch_turns]

  # customer page for Dairy logon Start
  def dairy_home
    @makesheets = Makesheet.order('make_date DESC')
  #  @makesheets = @makesheets.last(7)
  end
  
  def nursery_home
    @makesheets = Makesheet.where(grade: "").order('make_date DESC')
   
  end
  
  def makesheet_search
   # @makesheets = Makesheet.all
    
       if params[:search_by_batch] && params[:search_by_batch] != ""
         @makesheets = Makesheet.where(batch: params[:search_by_batch])
       end
      
  end
  
  def batch_turns
    @turns = @makesheet.turns.ordered
    
    @batch_turns_graph_data = get_data(@makesheet)
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
    

    def get_data(makesheet)
      @age_counter = (Date.today.year * 12 + Date.today.month) - (makesheet.make_date.year * 12 + makesheet.make_date.month)
      @batch_turns_graph_data = Hash.new{|h,k| h[k] = [] }
      compare_date = makesheet.make_date
      
      while @age_counter>=0
        t_count = Turn.where(makesheet_id: makesheet).where('turn_date< ?', (compare_date)).count
        @batch_turns_graph_data.store(compare_date.to_formatted_s(:uk_m_y), t_count)
        @age_counter = @age_counter-1 
        compare_date = compare_date+1.month
      end
      # logger.debug "++++++++++count: #{@batch_turns_graph_data.inspect}"
      return @batch_turns_graph_data
    end
end
