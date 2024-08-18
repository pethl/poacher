class TurnsController < ApplicationController
  before_action :set_turn, only: %i[ show edit update destroy ]

  # customer page for Dairy logon Start
  def store_home
    @turns = Turn.order('turn_date DESC')
 
  end
  
  # GET /turns or /turns.json
  def index
    @turns = Turn.all
  end

  # GET /turns/1 or /turns/1.json
  def show
      @makesheets = Makesheet.all.order(:make_date)
  end

  # GET /turns/new
  def new
    @turn = Turn.new
    @makesheets = Makesheet.all.order(:make_date)
  end

  # GET /turns/1/edit
  def edit
      @makesheets = Makesheet.all.order(:make_date)
  end

  # POST /turns or /turns.json
  def create
    @turn = Turn.new(turn_params)
     @makesheets = Makesheet.all.order(:make_date)

    respond_to do |format|
      if @turn.save
        format.html { redirect_to turn_url(@turn), notice: "Turn was successfully created." }
        format.json { render :show, status: :created, location: @turn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turns/1 or /turns/1.json
  def update
    respond_to do |format|
      if @turn.update(turn_params)
        format.html { redirect_to turn_url(@turn), notice: "Turn was successfully updated." }
        format.json { render :show, status: :ok, location: @turn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turns/1 or /turns/1.json
  def destroy
    @turn.destroy

    respond_to do |format|
      format.html { redirect_to turns_url, notice: "Turn was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turn
      @turn = Turn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def turn_params
      params.require(:turn).permit(:turn_date, :makesheet_id, :turned_by)
    end
end
