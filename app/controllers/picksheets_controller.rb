class PicksheetsController < ApplicationController
  require 'prawn'
  require 'prawn/table'
  before_action :authenticate_user!
  before_action :set_picksheet, only: %i[ show edit update destroy print_picksheet_pdf ]
  before_action :set_picksheets, only: [:index, :open_picksheets, :assigned_picksheets, :shipped_picksheets]
  
  # GET /picksheets or /picksheets.json
  def open_picksheets
    @picksheets = @picksheets.where(status: "Open")
    @type = "OPEN"
    render :index
  end

  def assigned_picksheets
    @picksheets = @picksheets.where(status: "Assigned")
    @type = "ASSIGNED"
    render :index
  end

  def shipped_picksheets
    @picksheets = @picksheets.where(status: "Shipped")
    @type = "SHIPPED"
    render :index
  end

  def index
    # All picksheets (no status filter)
    @type = "ALL"
  end

  # GET /picksheets/1 or /picksheets/1.json
  def show
     @picksheet_items = @picksheet.picksheet_items.ordered
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
    @picksheet.status = "Open"

    respond_to do |format|
      if @picksheet.save
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
    raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  
      pdf = Prawn::Document.new
      pdf.font_families.update(
        'raleway' => {
          normal: raleway_font_path, # Path to the normal (regular) font style
          bold: raleway_bold_font_path # Path to the bold font style (if applicable)
        }
      )
      pdf.font "raleway"
    
      @start_date = Date.today.beginning_of_year # Current vacation calendar year
      @picksheet = Picksheet.find(params[:id])
      @picksheet_items = PicksheetItem.where(picksheet_id: @picksheet.id)
    
    
      # pdf.text " ..:: LINCOLNSHIRE POACHER ::.. "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 10, align: :center
       pdf.text "Picking Sheet", size: 14, style: :bold, align: :left
       pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y')+"\n", size: 6, align: :left
       pdf.text "\n", size: 8  

       picksheet_header_table_data = Array.new
       picksheet_header_table_data << ["Date Order Placed:", @picksheet.date_order_placed.to_datetime.strftime('%b %d, %Y'), "Customer:", @picksheet.contact.business_name+"\n"+@picksheet.contact.contact_name]
       picksheet_header_table_data << ["Delivery Required By:", @picksheet.full_delivery_info, "Contact Telephone:", @picksheet.contact_telephone_number.presence || ""]
       picksheet_header_table_data << ["Order Number:", @picksheet.order_number, "Invoice Number:", @picksheet.invoice_number]
       picksheet_header_table_data << ["","","Carrier:", @picksheet.carrier]
       picksheet_header_table_data << ["No of Boxes:", (@picksheet.number_of_boxes.to_s unless @picksheet.number_of_boxes.to_s.empty?), "Carrier Delivery Date:", (@picksheet.carrier_delivery_date.to_datetime.strftime('%b %d, %Y') unless @picksheet.carrier_delivery_date.to_s.empty?)]
      
              pdf.table(picksheet_header_table_data) do 
                self.width = 460
                 self.cell_style = { :inline_format => true, size: 10 } 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_lines =>[:dashed, :dotted, :dotted, :dotted],
                 :border_color => "B2BEB5",}
               #  row(0).font_style = :bold  #for some reason this isnt working
                 columns(0).width = 110
                 columns(1).width = 120
                 columns(2).width = 110
                 columns(3).width = 120
                 columns(0).align = :right
                 columns(1).align = :center
                 columns(2).align = :right
                 columns(3).align = :center
                 columns(0).background_color = "D3D3D3"
                 columns(2).background_color = "D3D3D3"
                 columns(0).size = 7
                 columns(2).size = 7
               end
        pdf.move_down 20
       
          picksheet_item_table_data = Array.new
          picksheet_item_table_data << ["Product", "Size", "Count", "Weight(kg)", "Code", "Sp Price", "B/B Date"]
          @picksheet_items.each do |item|
             picksheet_item_table_data << [item.product, item.size, item.count, item.get_weight, item.code, item.sp_price, (item.bb_date.to_datetime.strftime('%b %d, %Y') unless item.bb_date.to_s.empty?)]
          end
          pdf.table(picksheet_item_table_data) do 
             self.width = 460
             self.cell_style = { :inline_format => true, size: 10 } 
             {:borders => [:top, :left, :bottom, :right],
             :border_width => 1,
             :border_color => "B2BEB5"}
             row(0).background_color = "D3D3D3"
             row(0).size = 7
             columns(0).width = 84
             columns(1).width = 56
             columns(2).width = 40
             columns(3).width = 60
             columns(4).width = 60
             columns(5).width = 70
             columns(6).width = 90
             columns(1..4).align = :center
             column(5..6).align = :right
           end
           pdf.image logo_img_path, :at => [482,742], :width => 80 
           send_data pdf.render, filename: 'picking_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
       
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picksheet
      @picksheet = Picksheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def picksheet_params
      params.require(:picksheet).permit(:status, :date_order_placed, :delivery_required_by, :delivery_time_of_day, :order_number, :contact_telephone_number, :invoice_number, :carrier, :carrier_delivery_date, :number_of_boxes, :contact_id, :user_id)
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
end
