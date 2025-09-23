class PicksheetsController < ApplicationController
  require 'prawn'
  require 'prawn/table'
  before_action :authenticate_user!
  before_action :set_picksheet, only: %i[ show edit update destroy print_picksheet_pdf ]
  before_action :set_picksheets, only: [:index, :hold_picksheets, :assigned_picksheets, :cutting_picksheets, :shipped_picksheets, :daily_cheese_manifest, :dispatch_and_collection]
  
  # GET /picksheets or /picksheets.json
  def hold_picksheets
    @picksheets = @picksheets.where(status: "Hold")
    @type = "HOLD"
    render :index
  end

  def assigned_picksheets
    @picksheets = @picksheets.where(status: "Assigned")
    @type = "ASSIGNED"
    render :index
  end

  def move_to_cutting_room
    @picksheets = Picksheet.where(status: "Assigned")
    @picksheets.update_all(status: "Cutting")
  
    redirect_to assigned_picksheets_picksheets_path, notice: "Picksheets moved to Cutting Room!"
  end

  def cutting_picksheets
    @picksheets = @picksheets.where(status: "Cutting")
    @type = "CUTTING"
    render :index
  end

  def shipped_picksheets
    @picksheets = @picksheets.where(status: "Shipped")
    @type = "SHIPPED"
    render :index
  end

  def index
    if params[:start_date].present? && params[:end_date].present? && params[:include_asap].present?
      @type = "DUE_THIS_WEEK"
    elsif params[:start_date].present? && params[:end_date].nil?
      @type = "DUE_LATER"
    else
      @type = "ALL"
    end
  end

  def daily_cheese_manifest
    @type = 'MANIFEST'
    # Fetch the assigned picksheets and their items
    @assigned_picksheets = Picksheet.where(status: "Assigned")
    @assigned_picksheet_items = PicksheetItem.where(picksheet_id: @assigned_picksheets.pluck(:id))

    # Group data by product, size, and wedge_size
   
    @final_grouped_items = group_picksheet_items(@assigned_picksheet_items)

    #code for product > customer table
    # Define desired product order
    @product_names =  Reference.where(active: true, group: 'sale_product').order(:sort_order).pluck(:value)# Customize this order

    # Build a hash of product => list of business_names
    @product_to_business_names = Hash.new { |h, k| h[k] = [] }

    # Fetch all assigned picksheets with their items and contacts
    assigned_picksheets = Picksheet.includes(:contact, :picksheet_items).where(status: "Assigned")

    assigned_picksheets.each do |picksheet|
      contact_name = picksheet.contact.business_name

      picksheet.picksheet_items.each do |item|
        product_name = item.product.strip
        if @product_names.include?(product_name)
          @product_to_business_names[product_name] << contact_name
        end
      end
    end
  end

  def dispatch_and_collection

     @type = 'DISPATCH'

      @assigned_picksheets = Picksheet.includes(:contact)
                                      .where(status: 'Assigned')
                                      .where.not(carrier: [nil, ''])
                                      .order('contacts.business_name ASC')

                                      # Separate the records where carrier is "Langdons" or "Palletline"
      @special_carriers = @assigned_picksheets.select { |p| ['Langdons', 'Palletline'].include?(p.carrier) }

      # Get the rest of the records
      @other_carriers = @assigned_picksheets.reject { |p| ['Langdons', 'Palletline'].include?(p.carrier) }

      # Group both arrays by carrier
      @grouped_picksheets = (@special_carriers + @other_carriers).group_by(&:carrier)

      # Combine "Tim to Deliver" and "Customer Collect" under a new name
      combined_carriers = @assigned_picksheets.select { |p| ['Tim to Deliver', 'Customer Collect'].include?(p.carrier) }
      @grouped_picksheets['Get ready for Tim or farm collections'] = combined_carriers

      # Remove the individual carrier entries for "Tim to Deliver" and "Customer Collect"
      @grouped_picksheets.delete('Tim to Deliver')
      @grouped_picksheets.delete('Customer Collect')

      @prepayments = Picksheet.includes(:contact)
      .where(status: "Assigned", contacts: { pre_payment: true })
      .order("contacts.business_name ASC")

  end
  

  # GET /picksheets/1 or /picksheets/1.json
  def show
     @picksheet_items = @picksheet.picksheet_items.ordered
     @total_weight = @picksheet.total_weight_kg
  end

  # GET /picksheets/new
  def new
    @picksheet = Picksheet.new
    @contacts = Contact.all.ordered
  end

  # GET /picksheets/1/edit
  def edit
    @contacts = Contact.all.ordered
  end

  # POST /picksheets or /picksheets.json
  def create
    @contacts = Contact.all.ordered

    @picksheet = Picksheet.new(picksheet_params)
    @picksheet.user_id = current_user.id  # Associate the picksheet with the current user
    #@picksheet.status = "Open" value is set in DB instead

    respond_to do |format|
      if @picksheet.save
       # 2.times { @picksheet.picksheet_items.create } doesnt work because of turbo

        format.html { redirect_to picksheet_url(@picksheet), notice: "Picking Sheet was successfully created." }
        format.json { render :show, status: :created, location: @picksheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picksheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /picksheets/1 or /picksheets/1.json
  def update
    respond_to do |format|
      if @picksheet.update(picksheet_params)
        format.html { redirect_to picksheet_url(@picksheet), notice: "Picking Sheet was successfully updated." }
        format.json { render :show, status: :ok, location: @picksheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picksheet.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # DELETE /picksheets/1 or /picksheets/1.json
  def destroy
    @picksheet.destroy

    respond_to do |format|
      format.html { redirect_to picksheets_url, notice: "Picksheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def print_picksheet_pdf
    @picksheet = Picksheet.find(params[:id])
  
    pdf_data = Rails.cache.fetch(["picksheet_pdf", @picksheet.id, @picksheet.updated_at.to_i], expires_in: 12.hours) do
      PicksheetPdfService.new(@picksheet).generate
    end
  
    send_data pdf_data, filename: "picking_sheet.pdf", type: "application/pdf", disposition: "inline"
  end

  def summary
    @picksheet = Picksheet.includes(:contact, :user, :picksheet_items).find(params[:id])
    render layout: false if turbo_frame_request?
  end
  

  def print_manifest_pdf
    @assigned_picksheets = Picksheet.where(status: "Assigned")
    @assigned_picksheet_items = PicksheetItem.where(picksheet_id: @assigned_picksheets.pluck(:id))
    @final_grouped_items = group_picksheet_items(@assigned_picksheet_items)

    @product_names =  Reference.where(active: true, group: 'sale_product').order(:sort_order).pluck(:value)# Customize this order
    @product_to_business_names = Hash.new { |h, k| h[k] = [] }
    @assigned_picksheets.each do |picksheet|
      business_name = picksheet.contact&.business_name
      picksheet.picksheet_items.each do |item|
        product_name = item.product.strip
        if @product_names.include?(product_name)
          @product_to_business_names[product_name] << business_name
        end
      end
    end

      pdf_data = PicksheetManifestPdfService.new(@final_grouped_items, @product_names, @product_to_business_names).generate

    if pdf_data.present?
      send_data pdf_data, filename: 'manifest_sheet.pdf', type: 'application/pdf', disposition: 'inline'
    else
      render plain: "PDF generation failed", status: :internal_server_error
    end
  end

  def print_dispatch_pdf
    @assigned_picksheets = Picksheet.includes(:contact)
    .where(status: 'Assigned')
    .where.not(carrier: [nil, ''])
    .order('contacts.business_name ASC')

    # Separate the records where carrier is "Langdons" or "Palletline"
    @special_carriers = @assigned_picksheets.select { |p| ['Langdons', 'Palletline'].include?(p.carrier) }

    # Get the rest of the records
    @other_carriers = @assigned_picksheets.reject { |p| ['Langdons', 'Palletline'].include?(p.carrier) }

    # Group both arrays by carrier
    @grouped_picksheets = (@special_carriers + @other_carriers).group_by(&:carrier)

    

    pdf_data = PicksheetDispatchPdfService.new(@grouped_picksheets).generate

    if pdf_data.present?
      send_data pdf_data, filename: 'dispatch_sheet.pdf', type: 'application/pdf', disposition: 'inline'
    else
      render plain: "PDF generation failed", status: :internal_server_error
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picksheet
      @picksheet = Picksheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def picksheet_params
      params.require(:picksheet).permit(:status, :date_order_placed, :delivery_required_by, :delivery_time_of_day, :order_number, :contact_telephone_number, :invoice_number, :carrier, :carrier_delivery_date, :carrier_collection_notes, :number_of_boxes, :contact_id, :user_id)
    end

    def set_picksheets
      @picksheets = Picksheet.all.ordered

      # Apply filter by delivery_required_by
      if params[:delivery_required_by].present?
        selected_date = Date.parse(params[:delivery_required_by]) rescue nil
        @picksheets = @picksheets.where(delivery_required_by: selected_date) if selected_date
      end

      # Apply filter by date_order_placed
      if params[:date_order_placed].present?
        selected_order_date = Date.parse(params[:date_order_placed]) rescue nil
        @picksheets = @picksheets.where(date_order_placed: selected_order_date) if selected_order_date
      end
  
      # Apply other date filtering (start_date, end_date, etc.)
      if params[:start_date].present? && params[:end_date].present?
        start_date = Date.parse(params[:start_date]) rescue nil
        end_date = Date.parse(params[:end_date]) rescue nil
        
        if start_date && end_date
          @picksheets = @picksheets.where("delivery_required_by BETWEEN ? AND ?", start_date, end_date)

          # Include records where delivery_required_by is NULL (ASAP)
          @picksheets = @picksheets.or(Picksheet.where(delivery_required_by: nil)) if params[:include_asap]
        end
      elsif params[:start_date].present? && params[:end_date].nil?
        # "Due Later" - delivery_required_by > end of this week
        end_of_week = Date.today.end_of_week
        @picksheets = @picksheets.where("delivery_required_by > ?", end_of_week)
      end
   end


   def group_picksheet_items(items)
    # Fetch the size order from the Reference model (group = "sale_size")
    size_order = Reference
    .where(group: "sale_size")
    .pluck(:value, :sort_order)
    .to_h

    # Debugging: Check what size_order looks like
    Rails.logger.debug "Size Order: #{size_order.inspect}"
  
    grouped_by_product = items.group_by(&:product)
  
    # Group items by product, size, and wedge_size, then sum the count
    final_grouped_items = {}
  
    grouped_by_product.each do |product, items|
      # Group by size and wedge_size
      final_grouped_items[product] = items
        .group_by { |item| [item.size, item.wedge_size] }  # Group by size and wedge_size
        .map do |size_and_wedge, items|
          total_count = items.sum(&:count)  # Sum the count field for this combination
          { size: size_and_wedge[0], wedge_size: size_and_wedge[1], count: total_count }
        end
  
      # Sort by the custom order from the Reference model
      final_grouped_items[product] = final_grouped_items[product].sort_by do |item|
        # Ensure we handle missing size values gracefully
        size_sort_order = size_order[item[:size]] || Float::INFINITY  # Default to a high number if missing
        [size_sort_order, item[:wedge_size]]
      end
    end
  
    # Return the grouped and sorted items
    final_grouped_items
  end
  end
