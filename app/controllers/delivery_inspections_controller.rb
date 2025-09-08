class DeliveryInspectionsController < ApplicationController
  before_action :set_delivery_inspection, only: %i[show edit update destroy]
  before_action :set_cheese_makers, only: %i[ new create edit update destroy ]

  
  def index
    # Filter by ingredient name (string), using your dairy_ingredients helper for the UI.
    @item_name = params[:item].presence

    base = DeliveryInspection
             .includes(:makesheets, :ingredient_batch_changes, :staff)
             .by_delivery_date_desc
    base = base.for_item(@item_name) if @item_name
    @delivery_inspections = base

    # Build: { "Salt" => <delivery_inspection_id of current batch> }
    @current_batch_id_by_item = latest_link_per_item
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
  def set_cheese_makers
    @cheese_makers = Staff.where(dept: "Cheesemaking Team").where(employment_status: "Active").ordered
  end

  def delivery_inspection_params
    params.require(:delivery_inspection).permit(
      :delivery_date, :item, :batch_no, :best_before,
      :cert_received, :damage, :foreign_contam, :pest_contam,
      :timely_delivery, :satisfactory, :comments,
      :staff_id, :staff_signature, :apply_hold
    )
  end

   # The “current batch” for an item is the DI linked to the latest makesheet.make_date.
   def latest_link_per_item
    rows = IngredientBatchChange
             .joins(:makesheet, :delivery_inspection)
             .select(
               "ingredient_batch_changes.item AS item_name, " \
               "delivery_inspections.id AS di_id, " \
               "makesheets.make_date AS used_at"
             )

    latest = {}
    rows.each do |r|
      item = r.item_name
      next if item.blank? || r.used_at.blank?
      if latest[item].nil? || r.used_at > latest[item][:used_at]
        latest[item] = { di_id: r.di_id, used_at: r.used_at }
      end
    end

    latest.transform_values { |v| v[:di_id] }
  end
end
