class PicksheetsController < ApplicationController
  require 'prawn'
  require 'prawn/table'
 

  before_action :set_picksheet, only: %i[ show edit update destroy print_picksheet_pdf ]

  # GET /picksheets or /picksheets.json
  def sales_home
    @picksheets = Picksheet.all.order(:date_order_placed)
  end
  
  # GET /picksheets or /picksheets.json
  def index
    @picksheets = Picksheet.all
  end

  # GET /picksheets/1 or /picksheets/1.json
  def show
     @picksheet_items = @picksheet.picksheet_items.ordered
     
  end

  # GET /picksheets/new
  def new
    @picksheet = Picksheet.new
  end

  # GET /picksheets/1/edit
  def edit
  end

  # POST /picksheets or /picksheets.json
  def create
    @picksheet = Picksheet.new(picksheet_params)

    respond_to do |format|
      if @picksheet.save
        format.html { redirect_to picksheet_url(@picksheet), notice: "Picksheet was successfully created." }
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
        format.html { redirect_to picksheet_url(@picksheet), notice: "Picksheet was successfully updated." }
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
       picksheet_header_table_data << ["Date Order Placed:", @picksheet.date_order_placed.to_datetime.strftime('%b %d, %Y'), "Customer:", "Fake Name"]
       picksheet_header_table_data << ["Delivery Required By:", @picksheet.delivery_required_by.to_datetime.strftime('%b %d, %Y'), "Contact Telephone:", @picksheet.contact_telephone_number.to_s]
       picksheet_header_table_data << ["Order Number:", @picksheet.order_number, "Invoice Number:", @picksheet.invoice_number]
       picksheet_header_table_data << ["","","Carrier:", @picksheet.carrier]
       picksheet_header_table_data << ["No of Boxes:", @picksheet.number_of_boxes.to_s, "Carrier Delivery Date:", @picksheet.carrier_delivery_date.to_datetime.strftime('%b %d, %Y')]
      
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
          picksheet_item_table_data << ["Product", "Size", "Count", "Weight", "Code", "Sp Price", "B/B Date"]
          @picksheet_items.each do |item|
             picksheet_item_table_data << [item.product, item.size, item.count, item.weight, item.code, item.sp_price, item.bb_date]
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
      params.require(:picksheet).permit(:date_order_placed, :delivery_required_by, :order_number, :contact_telephone_number, :invoice_number, :carrier, :carrier_delivery_date, :number_of_boxes)
    end
end