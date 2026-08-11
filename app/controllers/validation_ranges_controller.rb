class ValidationRangesController < ApplicationController
  include ApplicationHelper # used for validated_models / field name setup

  before_action :authenticate_user!
  before_action :set_validation_range, only: %i[show edit update destroy]

  # Office: manage · Dairy: manage (dual owner, confirmed intentional).
  before_action :authorize_validation_range_read!, only: %i[index show]
  before_action :authorize_validation_range_manage!, only: %i[new create edit update destroy]

  # GET /validation_ranges
  def index
    scope =
      if params[:model].present?
        ValidationRange.where(target_model: params[:model])
      else
        ValidationRange.all
      end

    @validation_ranges = scope.ordered_by_field_name
  end

  # GET /validation_ranges/1
  def show
  end

  # GET /validation_ranges/new
  def new
    @validation_range = ValidationRange.new(active: true)
    setup_model_and_fields
  end

  # GET /validation_ranges/1/edit
  def edit
    @model_name = @validation_range.target_model
    @field_options = Array(field_names_for(@model_name))
  end

  # POST /validation_ranges
  def create
    @validation_range = ValidationRange.new(validation_range_params)

    @model_name = @validation_range.target_model
    @field_options = Array(field_names_for(@model_name))

    respond_to do |format|
      if @validation_range.save
        format.html {
          redirect_to @validation_range,
                      notice: "Validation range was successfully created."
        }

        format.json {
          render :show,
                 status: :created,
                 location: @validation_range
        }
      else
        format.html {
          render :new,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @validation_range.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  # PATCH/PUT /validation_ranges/1
  def update
    @model_name = @validation_range.target_model
    @field_options = Array(field_names_for(@model_name))

    respond_to do |format|
      if @validation_range.update(validation_range_params)
        format.html {
          redirect_to @validation_range,
                      notice: "Validation range was successfully updated."
        }

        format.json {
          render :show,
                 status: :ok,
                 location: @validation_range
        }
      else
        format.html {
          render :edit,
                 status: :unprocessable_entity
        }

        format.json {
          render json: @validation_range.errors,
                 status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /validation_ranges/1
  def destroy
    @validation_range.destroy!

    respond_to do |format|
      format.html {
        redirect_to validation_ranges_path,
                    status: :see_other,
                    notice: "Validation range was successfully destroyed."
      }

      format.json { head :no_content }
    end
  end

  private

  def set_validation_range
    @validation_range = ValidationRange.find(params[:id])
  end

  def authorize_validation_range_read!
    authorize! :read, @validation_range || ValidationRange
  end

  def authorize_validation_range_manage!
    authorize! :manage, @validation_range || ValidationRange
  end

  def validation_range_params
    params.require(:validation_range).permit(
      :target_model,
      :field_name,
      :min_value,
      :max_value,
      :active
    )
  end

  def field_names_for(model_name)
    klass = model_name.to_s.safe_constantize
    return [] unless klass && klass < ApplicationRecord

    klass.columns
         .select { |column| column.type.in?([:integer, :float, :decimal]) }
         .reject do |column|
           column.name.in?(%w[id created_at updated_at]) ||
             column.name.ends_with?("_id")
         end
         .map(&:name)
         .sort
  end

  def setup_model_and_fields
    models = validated_models

    @model_name =
      params[:model_name].presence_in(models) ||
      @validation_range.target_model.presence_in(models) ||
      models.first

    @validation_range.target_model ||= @model_name
    @field_options = field_names_for(@model_name)
  end
end