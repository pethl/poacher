class MarketSalesController < ApplicationController
  before_action :set_market_sale, only: %i[ show edit update destroy ]
  before_action :set_existing_names, only: [:new, :edit]

  # GET /market_sales or /market_sales.json
  def index
    @market_sales = MarketSale.all

    # Filtering by month
    if params[:month].present?
      @market_sales = @market_sales.where("extract(month from sale_date) = ?", params[:month])
    end

    # Filtering by year
    if params[:year].present?
      @market_sales = @market_sales.where("extract(year from sale_date) = ?", params[:year])
    end

    # Filtering by market
    if params[:market].present?
      @market_sales = @market_sales.where(market: params[:market])
    end

    # Filtering by who
    if params[:who].present?
      @market_sales = @market_sales.where(who: params[:who])
    end

    # Sorting the records by date and market
    @market_sales = @market_sales.sorted_by_date_and_market
  end

  def summary
    #   # Get the year from params or default to the current year 
    #   @year = params[:year] || Date.today.year 
    #   @year = @year.to_i 
      
    #   # Fetch all MarketSales for the selected year 
    #   @market_sales = MarketSale.where(sale_date: Date.new(@year, 1, 1)..Date.new(@year, 12, 31)) 
      
    #   # Group by month and calculate totals 
    #   @summary_data = @market_sales.group_by {|sale| sale.sale_date.month }.transform_values do |sales| { cheesey_sales: sales.sum { |sale| sale.cheese_sales.to_d }, sales.sum { |sale| sale.butter_sales.to_d }
      
     
    # end 
    #   # Fill in missing months with zero values 
    #   @summary_data = (1..12).each_with_object({}) do |month, hash| hash[month] = @summary_data.fetch(month, { cheesey_sales: 0, buttery_sales: 0 }) 
    # end 

  year = params[:year] || Date.today.year

  sales_data = MarketSale.where("EXTRACT(YEAR FROM sale_date) = ?", year)
                         .group("EXTRACT(MONTH FROM sale_date)")
                         .pluck(
                           Arel.sql("EXTRACT(MONTH FROM sale_date)"),
                           Arel.sql("COALESCE(SUM(cheese_sales), 0)"),
                           Arel.sql("COALESCE(SUM(butter_sales), 0)"),
                           Arel.sql("COALESCE(SUM(plum_bread), 0)"),
                           Arel.sql("COALESCE(SUM(milk), 0)"),
                           Arel.sql("COALESCE(SUM(other_cheese), 0)")
                         )

    @sales_data = sales_data.each_with_object({}) do |(month, cheese, butter, plum, milk, other_cheese), hash|
      hash[month.to_i] = {
        cheese_sales: cheese,
        butter_sales: butter,
        plum_bread: plum,
        milk: milk,
        other_cheese: other_cheese
      }
    end

    @months = (1..12).to_a

    @monthly_totals = MarketSale.where(sale_date: @year_range)
  .group("EXTRACT(MONTH FROM sale_date)")
  .sum("cheese_sales + butter_sales + honey_sales + egg_sales + plum_bread + milk + other_cheese")

  end 

  # GET /market_sales/1 or /market_sales/1.json
  def show
  end

  # GET /market_sales/new
  def new
    @market_sale = MarketSale.new
  end

  # GET /market_sales/1/edit
  def edit
  end

  # POST /market_sales or /market_sales.json
  def create
    @market_sale = MarketSale.new(market_sale_params)

    respond_to do |format|
      if @market_sale.save
        format.html { redirect_to @market_sale, notice: "Market sale was successfully created." }
        format.json { render :show, status: :created, location: @market_sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @market_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /market_sales/1 or /market_sales/1.json
  def update
    respond_to do |format|
      if @market_sale.update(market_sale_params)
        format.html { redirect_to @market_sale, notice: "Market sale was successfully updated." }
        format.json { render :show, status: :ok, location: @market_sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @market_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /market_sales/1 or /market_sales/1.json
  def destroy
    @market_sale.destroy

    respond_to do |format|
      format.html { redirect_to market_sales_path, status: :see_other, notice: "Market sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market_sale
      @market_sale = MarketSale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def market_sale_params
      params.require(:market_sale).permit(:who, :market, :sale_date, :cheese_sales, :butter_sales, :honey_sales, :egg_sales, :plum_bread, :milk, :other_cheese, :total_sales, :weight)
    end

    def set_existing_names
      @existing_names = MarketSale.where.not(who: [nil, ""]).distinct.pluck(:who)
    end
end
