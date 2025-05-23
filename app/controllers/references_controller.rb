class ReferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reference, only: %i[ show edit update destroy ]

  # GET /references or /references.json
  def index
    @references = Reference.all.order(group: :asc, id: :asc)
    @references = Reference.all
    @references = @references.where(group: params[:group]) if params[:group].present?
    @references = @references.where(model: params[:model]) if params[:model].present?

    @references_by_model_and_group = @references.group_by(&:model).transform_values do |refs|
      refs.group_by(&:group)
    end

  end

  # GET /references/1 or /references/1.json
  def show
  end

  # GET /references/new
  def new
    #@reference = Reference.new
    @reference = Reference.new(group: params[:group], model: params[:model])
  end

  # GET /references/1/edit
  def edit
  end

  # POST /references or /references.json
  def create
    @reference = Reference.new(reference_params)

    respond_to do |format|
      if @reference.save
        format.html { redirect_to reference_url(@reference), notice: "Reference was successfully created." }
        format.json { render :show, status: :created, location: @reference }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /references/1 or /references/1.json
  def update
    respond_to do |format|
      if @reference.update(reference_params)
        format.html { redirect_to reference_url(@reference), notice: "Reference was successfully updated." }
        format.json { render :show, status: :ok, location: @reference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /references/1 or /references/1.json
  def destroy
    @reference.destroy

    respond_to do |format|
      format.html { redirect_to references_url, notice: "Reference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference
      @reference = Reference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reference_params
      params.require(:reference).permit(:group, :value, :description, :active, :sort_order, :model)
    end
end
