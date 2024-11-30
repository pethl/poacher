class ButterMakesController < ApplicationController
  before_action :set_butter_make, only: %i[ show edit update destroy ]

  # GET /butter_makes or /butter_makes.json
  def index
    @butter_makes = ButterMake.all.ordered
  end

  # GET /butter_makes/1 or /butter_makes/1.json
  def show
  end

  # GET /butter_makes/new
  def new
    @butter_make = ButterMake.new
  end

  # GET /butter_makes/1/edit
  def edit
  end

  # POST /butter_makes or /butter_makes.json
  def create
    @butter_make = ButterMake.new(butter_make_params)

    respond_to do |format|
      if @butter_make.save
        format.html { redirect_to @butter_make, notice: "Butter make was successfully created." }
        format.json { render :show, status: :created, location: @butter_make }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @butter_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /butter_makes/1 or /butter_makes/1.json
  def update
    respond_to do |format|
      if @butter_make.update(butter_make_params)
        format.html { redirect_to @butter_make, notice: "Butter make was successfully updated." }
        format.json { render :show, status: :ok, location: @butter_make }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @butter_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /butter_makes/1 or /butter_makes/1.json
  def destroy
    @butter_make.destroy

    respond_to do |format|
      format.html { redirect_to butter_makes_path, status: :see_other, notice: "Butter make was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_butter_make
      @butter_make = ButterMake.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def butter_make_params
      params.require(:butter_make).permit(:date, :cream, :make, :stock)
    end
end
