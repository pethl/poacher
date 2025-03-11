class StaffsController < ApplicationController
  before_action :set_staff, only: %i[ show edit update destroy ]

  # GET /staffs or /staffs.json
  def index

       # Filtering by active or inactive status
       if params[:employment_status] == 'Inactive'
        @staffs = Staff.where(employment_status: "Inactive")
      else
        # Default to Active staff
        @staffs = Staff.where(employment_status: "Active")
      end

      # Sorting logic
      if params[:column].present?
        @staffs = @staffs.order("#{params[:column]} #{params[:direction]}")
      else
        @staffs = @staffs.ordered
      end
  end

  # GET /staffs/1 or /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
  end 

  # GET /staffs/1/edit
  def edit
  end

  # POST /staffs or /staffs.json
  def create
    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to staffs_url, notice: "Staff record was successfully created." }
        format.json { render :show, status: :created, location: @staff }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1 or /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        format.html { redirect_to staffs_url, notice: "Staff record was successfully updated." }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1 or /staffs/1.json
  def destroy
    @staff.destroy

    respond_to do |format|
      format.html { redirect_to staffs_url, notice: "Staff was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def staff_params
      params.require(:staff).permit(:first_name, :last_name, :employment_status, :dept, :role)
    end
end
