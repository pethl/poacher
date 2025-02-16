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

    @year = params[:year] || Date.current.year # Default to current year if no year is selected
  
    # ✅ FIX: Wrap EXTRACT() in Arel.sql() to avoid the dangerous query warning
    @monthly_sales = MarketSale
      .select(Arel.sql("EXTRACT(MONTH FROM sale_date) as month, 
                        SUM(cheese_sales) as cheese_total, 
                        SUM(butter_sales) as butter_total, 
                        SUM(honey_sales) as honey_total, 
                        SUM(egg_sales) as egg_total, 
                        SUM(plum_bread) as plum_bread_total, 
                        SUM(milk) as milk_total, 
                        SUM(other_cheese) as other_cheese_total, 
                        SUM(total_sales) as total_sales"))
      .where("EXTRACT(YEAR FROM sale_date) = ?", @year)
      .group(Arel.sql("EXTRACT(MONTH FROM sale_date)"))
      .order(Arel.sql("EXTRACT(MONTH FROM sale_date)"))
  
    # ✅ FIX: Wrap EXTRACT() in Arel.sql() to avoid the dangerous query warning
    @years = MarketSale.pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM sale_date)")).sort.reverse
  
    # Check if there are no records, in case @monthly_sales is nil or empty
    if @monthly_sales.present?
      # Organizing sales by product
      @sales_by_product = {
        "Cheese" => Hash.new(0),
        "Butter" => Hash.new(0),
        "Honey" => Hash.new(0),
        "Eggs" => Hash.new(0),
        "Plum Bread" => Hash.new(0),
        "Milk" => Hash.new(0),
        "Other Cheese" => Hash.new(0),
        "Total Sales" => Hash.new(0)
      }
  
      @monthly_sales.each do |sale|
        # Ensure that the sales values are converted to float, defaulting to 0 if nil
        @sales_by_product["Cheese"][sale.month.to_i] = sale.cheese_total.to_f
        @sales_by_product["Butter"][sale.month.to_i] = sale.butter_total.to_f
        @sales_by_product["Honey"][sale.month.to_i] = sale.honey_total.to_f
        @sales_by_product["Eggs"][sale.month.to_i] = sale.egg_total.to_f
        @sales_by_product["Plum Bread"][sale.month.to_i] = sale.plum_bread_total.to_f
        @sales_by_product["Milk"][sale.month.to_i] = sale.milk_total.to_f
        @sales_by_product["Other Cheese"][sale.month.to_i] = sale.other_cheese_total.to_f
        @sales_by_product["Total Sales"][sale.month.to_i] = sale.total_sales.to_f
      end
    else
      # Handle the case when there are no monthly sales for the selected year
      @sales_by_product = {}
    end
  end

  def summary_end
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
