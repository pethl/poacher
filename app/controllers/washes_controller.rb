class WashesController < ApplicationController
  before_action :set_wash, only: %i[ show edit update destroy ]

  # GET /washes or /washes.json
  def index
    @washes = Wash.all
  end

  # GET /washes/1 or /washes/1.json
  def show
    @picksheetitems = PicksheetItem.where(picksheet_id: WashPicksheet.where(wash_id: @wash).pluck(:picksheet_id))
  end

  # GET /washes/new
  def new
    @wash = Wash.new
    #.or(Picksheet.where(status: "Open")) NOT YET IMPLEMENTED NEED STATUS SET FOR PICKING
    
    @picksheets = Picksheet.where("delivery_required_by>= ?", Date.today).pluck(:id) 
    @picksheets_already_assigned_to_a_wash = (WashPicksheet.all.pluck(:picksheet_id))
    @picksheets_subset = @picksheets.reject {|n| @picksheets_already_assigned_to_a_wash.include? n}
    @picksheets_subset = Picksheet.find(@picksheets_subset)
  #  @picksheets_subset = @picksheets_subset.order(delivery_required_by: :asc)
    
  end

  # GET /washes/1/edit
  def edit
    @picksheets = Picksheet.where("delivery_required_by>= ?", Date.today)
   # @picksheets_already_assigned_to_a_wash = (WashPicksheet.all.pluck(:picksheet_id))
  #  @picksheets_subset = @picksheets.reject {|n| @picksheets_already_assigned_to_a_wash.include? n}
  #  @picksheets_subset = Picksheet.find(@picksheets_subset)
   @picksheets_subset = @picksheets
  end

  # POST /washes or /washes.json
  def create
    @wash = Wash.new(wash_params)

    respond_to do |format|
      if @wash.save
        format.html { redirect_to wash_url(@wash), notice: "Wash was successfully created." }
        format.json { render :show, status: :created, location: @wash }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wash.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /washes/1 or /washes/1.json
  def update
    respond_to do |format|
      if @wash.update(wash_params)
        format.html { redirect_to wash_url(@wash), notice: "Wash was successfully updated." }
        format.json { render :show, status: :ok, location: @wash }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wash.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /washes/1 or /washes/1.json
  def destroy
    @wash.destroy

    respond_to do |format|
      format.html { redirect_to washes_url, notice: "Wash was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wash
      @wash = Wash.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wash_params
      params.require(:wash).permit(:action_date, :wash_status, picksheet_ids: [])
    end
end
