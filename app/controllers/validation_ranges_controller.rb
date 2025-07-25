class ValidationRangesController < ApplicationController
  include ApplicationHelper #to load the model name for validation field_names
  before_action :set_validation_range, only: %i[ show edit update destroy ]

  # GET /validation_ranges or /validation_ranges.json
  def index
    scope = if params[:model].present?
      ValidationRange.where(target_model: params[:model])
    else
      ValidationRange.all
    end
  
    @validation_ranges = scope.ordered_by_field_name
  end

  # GET /validation_ranges/1 or /validation_ranges/1.json
  def show
  end

  # GET /validation_ranges/new
  def new
    @validation_range = ValidationRange.new
    @validation_range.active = true

    setup_model_and_fields
   end

  # GET /validation_ranges/1/edit
  def edit
    @field_options = Array(field_names_for(@model_name))
  end

  # POST /validation_ranges or /validation_ranges.json
  def create
    @validation_range = ValidationRange.new(validation_range_params)
    @validation_range.created_by = current_user.id
    @validation_range.updated_by = current_user.id
    @field_options = Array(field_names_for(@model_name))

    respond_to do |format|
      if @validation_range.save
        format.html { redirect_to @validation_range, notice: "Validation range was successfully created." }
        format.json { render :show, status: :created, location: @validation_range }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @validation_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /validation_ranges/1 or /validation_ranges/1.json
  def update
    @validation_range.updated_by = current_user.id
    
    respond_to do |format|
      if @validation_range.update(validation_range_params)
        format.html { redirect_to @validation_range, notice: "Validation range was successfully updated." }
        format.json { render :show, status: :ok, location: @validation_range }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @validation_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /validation_ranges/1 or /validation_ranges/1.json
  def destroy
    @validation_range.destroy!

    respond_to do |format|
      format.html { redirect_to validation_ranges_path, status: :see_other, notice: "Validation range was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation_range
      @validation_range = ValidationRange.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def validation_range_params
      params.require(:validation_range).permit(:target_model, :field_name, :min_value, :max_value, :active)
    end

    def field_names_for(model_name)
      klass = model_name.to_s.safe_constantize
      return [] unless klass && klass < ApplicationRecord
    
      klass.columns
           .select { |c| c.type.in?([:integer, :float, :decimal]) }
           .reject { |c| c.name.in?(%w[id created_at updated_at]) || c.name.ends_with?('_id') }
           .map(&:name)
           .sort
    end
    
    def setup_model_and_fields
      models = validated_models
      @model_name = params[:model_name].presence_in(models) || models.first  # ← fallback to "Makesheet"
      @field_options = field_names_for(@model_name)
    end
end
