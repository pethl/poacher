class TurnsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_turn, only: %i[ show edit update destroy ]

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

  def bulk_create
    aisle = params[:aisle].to_i
  
    # Get all active locations in the given aisle (left + right)
    locations = Location.active_sorted.select { |loc| loc.aisle == aisle }
  
    count = 0
  
    locations.each do |location|
      makesheet = location.makesheet
      next if makesheet.blank?
      next if makesheet.turns.where("DATE(turn_date) = ?", Date.today).exists?
  
      makesheet.turns.create!(
        turn_date: Time.current,
        turned_by: current_user.full_name, # or just current_user.id if it's a relation
        created_by: current_user,
        updated_by: current_user
      )
  
      count += 1
    end
  
    redirect_to turns_path, notice: "#{count} turns created for Aisle #{aisle}."
  end

  def aisle_summary
    @shed_aisle_status = []
  
    [4, 5].each do |shed_number|
      (1..6).each do |aisle|
        # Find location for Shed X - Aisle Y - Col 3
        location = Location.active.find do |loc|
          loc.shed_number == shed_number &&
          loc.aisle == aisle &&
          loc.column_number == 3
        end
  
        makesheet = location&.makesheet
        last_turn = makesheet&.turns&.order(turn_date: :desc)&.first
  
        status = if last_turn&.turn_date && last_turn.turn_date >= 1.month.ago
                   :green
                 else
                   :red
                 end
  
        @shed_aisle_status << {
          shed: shed_number,
          aisle: aisle,
          location: location,
          makesheet: makesheet,
          last_turned_at: last_turn&.turn_date,
          status: status
        }
      end
    end
    @shed_aisle_status_by_shed = @shed_aisle_status.group_by { |entry| entry[:shed] }

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
