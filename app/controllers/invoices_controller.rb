class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  before_action :set_existing_names, only: [:new, :edit]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all

    # Filtering by month
    if params[:month].present?
      @invoices = @invoices.where("extract(month from date) = ?", params[:month])
    end

    # Filtering by year
    if params[:year].present?
      @invoices = @invoices.where("extract(year from date) = ?", params[:year])
    end 

    # Filtering by market
    if params[:account].present?
      @invoices = @invoices.where(account: params[:account])
    end
  end

  def summary
   # @years = Invoice.pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM date)")).compact.sort.reverse
    @years = params[:year] || Date.current.year # Default to current year if no year is selected

    @selected_year = params[:year] ? params[:year].to_i : @years

    @monthly_sales = Invoice.where("EXTRACT(YEAR FROM date) = ?", @selected_year)
    .group(Arel.sql("EXTRACT(MONTH FROM date)"))
    .pluck(Arel.sql("EXTRACT(MONTH FROM date) AS month, SUM(amount) AS total_amount, SUM(weight) AS total_weight"))
    .each_with_object({}) do |(month, total_amount, total_weight), hash|
      hash[month.to_i] = { amount: total_amount, weight: total_weight }
    end

    @year = params[:year] || Date.today.year
    @sales_data = Invoice
    .where("extract(year from date) = ?", @year)
    .group(Arel.sql("account, extract(month from date)"))
    .pluck(Arel.sql("account, extract(month from date)::int, SUM(amount), SUM(weight)"))

    @accounts = @sales_data.map(&:first).uniq.sort
    @monthly_totals = @sales_data.group_by(&:first) 
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_path, status: :see_other, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:number, :account, :date, :amount, :weight)
    end

    def set_existing_names
      @existing_names = Invoice.where.not(account: [nil, ""]).distinct.pluck(:account).sort

    end
end 
