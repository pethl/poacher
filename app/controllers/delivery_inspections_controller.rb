class DeliveryInspectionsController < ApplicationController
  before_action :set_delivery_inspection, only: %i[show edit update destroy]
  before_action :set_staffs,              only: %i[new edit create update]

  # GET /delivery_inspections
  def index
    @delivery_inspections = DeliveryInspection.by_delivery_date_desc
  end

  # GET /delivery_inspections/1
  def show; end

  # GET /delivery_inspections/new
  def new
    @delivery_inspection = DeliveryInspection.new(delivery_date: Date.current)
  end

  # GET /delivery_inspections/1/edit
  def edit; end

  # POST /delivery_inspections
  def create
    @delivery_inspection = DeliveryInspection.new(delivery_inspection_params)

    respond_to do |format|
      if @delivery_inspection.save
        format.html { redirect_to delivery_inspections_path, notice: "Delivery inspection was successfully created." }
        format.json { render :show, status: :created, location: @delivery_inspection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery_inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_inspections/1
  def update
    respond_to do |format|
      if @delivery_inspection.update(delivery_inspection_params)
        format.html { redirect_to delivery_inspections_path, notice: "Delivery inspection was successfully updated." }
        format.json  { render :show, status: :ok, location: @delivery_inspection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery_inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_inspections/1
  def destroy
    @delivery_inspection.destroy!
    respond_to do |format|
      format.html { redirect_to delivery_inspections_path, status: :see_other, notice: "Delivery inspection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_delivery_inspection
    @delivery_inspection = DeliveryInspection.find(params[:id])
  end

  # Single source of truth for staff list (used by form select)
  def set_staffs
    @staffs = Staff.where(employment_status: "Active").ordered
    # If you have scopes:
    # @staffs = Staff.active.ordered
  end

  def delivery_inspection_params
    params.require(:delivery_inspection).permit(
      :delivery_date, :item, :batch_no, :best_before,
      :cert_received, :damage, :foreign_contam, :pest_contam,
      :timely_delivery, :satisfactory, :comments,
      :staff_id, :staff_signature
    )
  end
end
