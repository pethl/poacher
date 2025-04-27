class CleaningForeignBodyChecksController < ApplicationController
  before_action :set_cleaning_foreign_body_check, only: %i[ show edit update destroy ]

  # GET /cleaning_foreign_body_checks or /cleaning_foreign_body_checks.json
  def index
    @cleaning_foreign_body_checks = CleaningForeignBodyCheck.all
  end

  def week_view
    @week_days = (Date.today.beginning_of_week(:monday)..Date.today.beginning_of_week(:monday) + 6.days).to_a
    @cleaning_checks = CleaningForeignBodyCheck.where(date: @week_days)
  end

  # GET /cleaning_foreign_body_checks/1 or /cleaning_foreign_body_checks/1.json
  def show
  end

  # GET /cleaning_foreign_body_checks/new
  def new
    @cleaning_foreign_body_check = CleaningForeignBodyCheck.new(date: params[:date])
    @staffs = Staff.where(employment_status: "Active").where(dept: "Cheesemaking Team").ordered
  end

  # GET /cleaning_foreign_body_checks/1/edit
  def edit
    @staffs = Staff.where(employment_status: "Active").where(dept: "Cheesemaking Team").ordered

  end

  # POST /cleaning_foreign_body_checks or /cleaning_foreign_body_checks.json
  def create
    @cleaning_foreign_body_check = CleaningForeignBodyCheck.new(cleaning_foreign_body_check_params)
    @staffs = Staff.where(employment_status: "Active").where(dept: "Cheesemaking Team").ordered

  
    respond_to do |format|
      if @cleaning_foreign_body_check.save
        format.html { redirect_to week_view_cleaning_foreign_body_checks_path, notice: "Cleaning foreign body check was successfully created." }
        format.json { render :show, status: :created, location: @cleaning_foreign_body_check }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cleaning_foreign_body_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cleaning_foreign_body_checks/1 or /cleaning_foreign_body_checks/1.json
  def update
    @staffs = Staff.where(employment_status: "Active").where(dept: "Cheesemaking Team").ordered

  
    respond_to do |format|
      if @cleaning_foreign_body_check.update(cleaning_foreign_body_check_params)
        format.html { redirect_to week_view_cleaning_foreign_body_checks_path, notice: "Cleaning foreign body check was successfully updated." }
        format.json { render :show, status: :ok, location: @cleaning_foreign_body_check }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cleaning_foreign_body_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cleaning_foreign_body_checks/1 or /cleaning_foreign_body_checks/1.json
  def destroy
    @cleaning_foreign_body_check.destroy!

    respond_to do |format|
      format.html { redirect_to cleaning_foreign_body_checks_path, status: :see_other, notice: "Cleaning foreign body check was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cleaning_foreign_body_check
      @cleaning_foreign_body_check = CleaningForeignBodyCheck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cleaning_foreign_body_check_params
      params.require(:cleaning_foreign_body_check).permit(:date, :milk_pipeline, :cheese_vat, :used_mill, :cooler_moulds_tables, :hand_equipment, :blue_food_contact_equipment, :plastic_sleeves, :metal_shovels, :aprons, :drain_lower_level, :drain_upper_level, :presses, :sinks, :floor_difficult_areas, :footbaths, :internal_door_handles, :change_chlorine, :floor_under_handwash, :compressors, :additional_comments, :staff_id, :staff_id_2, :staff_id_3)
    end
end
