class ButterStocksController < ApplicationController
  before_action :set_butter_stock, only: %i[ show edit update destroy ]

  # GET /butter_stocks or /butter_stocks.json
  def index
    @butter_stocks = ButterStock.all
  end

  # GET /butter_stocks/1 or /butter_stocks/1.json
  def show
  end

  # GET /butter_stocks/new
  def new
    @butter_stock = ButterStock.new
  end

  # GET /butter_stocks/1/edit
  def edit
  end

  # POST /butter_stocks or /butter_stocks.json
  def create
    @butter_stock = ButterStock.new(butter_stock_params)

    respond_to do |format|
      if @butter_stock.save
        format.html { redirect_to @butter_stock, notice: "Butter stock was successfully created." }
        format.json { render :show, status: :created, location: @butter_stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @butter_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /butter_stocks/1 or /butter_stocks/1.json
  def update
    respond_to do |format|
      if @butter_stock.update(butter_stock_params)
        format.html { redirect_to @butter_stock, notice: "Butter stock was successfully updated." }
        format.json { render :show, status: :ok, location: @butter_stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @butter_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /butter_stocks/1 or /butter_stocks/1.json
  def destroy
    @butter_stock.destroy

    respond_to do |format|
      format.html { redirect_to butter_stocks_path, status: :see_other, notice: "Butter stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_butter_stock
      @butter_stock = ButterStock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def butter_stock_params
      params.require(:butter_stock).permit(:make_date, :todays_make, :fresh_spare_for_sale, :market_returns_salted, :market_returns_hm2, :market_returns_unsalted, :freezer_stock_salted, :freezer_stock_hm2, :freezer_stock_unsalted, :family_butter_salted, :family_butter_hm2, :family_butter_unsalted)
    end
end
