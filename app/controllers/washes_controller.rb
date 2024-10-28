class WashesController < ApplicationController
  before_action :set_wash, only: %i[ show edit update destroy ]

  def wash_home
    @wash = Wash.where(wash_status: "Approved").first
    @todays_wash = Wash.last
    @wash_approved =  Wash.where(wash_status: "Approved").last
    @picksheetitems = PicksheetItem.where(picksheet_id: WashPicksheet.where(wash_id: @wash).pluck(:picksheet_id))
    @picksheetitems_by_product = @picksheetitems.group_by { |t| t.product }
  end
  
  # GET /washes or /washes.json
  def index
    @washes = Wash.all
  end

  # GET /washes/1 or /washes/1.json
  def show
    @picksheetitems = PicksheetItem.where(picksheet_id: WashPicksheet.where(wash_id: @wash).pluck(:picksheet_id))
    @picksheetitems_by_product = @picksheetitems.group_by { |t| t.product }
  end

  # GET /washes/new
  def new
    @wash = Wash.new
    #.or(Picksheet.where(status: "Open")) NOT YET IMPLEMENTED NEED STATUS SET FOR PICKING
    
    @picksheets = Picksheet.where("delivery_required_by>= ?", Date.today).pluck(:id) 
    @picksheets_already_assigned_to_a_wash = (WashPicksheet.all.pluck(:picksheet_id))
    @picksheets_subset = @picksheets.reject {|n| @picksheets_already_assigned_to_a_wash.include? n}
    @picksheets_subset = Picksheet.find(@picksheets_subset)
    @picksheets_subset = @picksheets_subset.sort_by { |picksheet| [picksheet.delivery_required_by] }
    
  end

  # GET /washes/1/edit
  def edit
    @picksheets = Picksheet.where("delivery_required_by>= ?", Date.today)
    @picksheets_subset = @picksheets.sort_by { |picksheet| [picksheet.delivery_required_by] }
  end

  # POST /washes or /washes.json
  def create
    @wash = Wash.new(wash_params)

    respond_to do |format|
      if @wash.save
        format.html { redirect_to wash_url(@wash), notice: "Wash was successfully created." }
        format.json { render :show, status: :created, location: @wash }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wash.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /washes/1 or /washes/1.json
  def update
    respond_to do |format|
      if @wash.update(wash_params)
        format.html { redirect_to wash_url(@wash), notice: "Wash was successfully updated." }
        format.json { render :show, status: :ok, location: @wash }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wash.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /washes/1 or /washes/1.json
  def destroy
    @wash.destroy

    respond_to do |format|
      format.html { redirect_to washes_url, notice: "Wash was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  
  def print_washsheet_pdf
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
      @washsheet = Wash.find(params[:id])
      @picksheetitems = PicksheetItem.where(picksheet_id: WashPicksheet.where(wash_id: @washsheet).pluck(:picksheet_id))
      @picksheetitems_by_product = @picksheetitems.group_by { |t| t.product }
 
      # pdf.text " ..:: LINCOLNSHIRE POACHER ::.. "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 10, align: :center
       pdf.text "Wash Sheet for "+@washsheet.action_date.to_datetime.strftime('%b %d, %Y'), size: 14, style: :bold, align: :left
       pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y'), size: 6, align: :left
       pdf.text "\n", size: 8  
       
       washsheet_header_table_data = Array.new
       washsheet_header_table_data << ["Action Date:", "Status:", "Approved By:"]
       washsheet_header_table_data << [ @washsheet.action_date.to_datetime.strftime('%b %d, %Y'), @washsheet.wash_status, "User Name"]
      
              pdf.table(washsheet_header_table_data) do 
                self.width = 300
                 self.cell_style = { :inline_format => true, size: 10 } 
                 {:borders => [:top, :left, :bottom, :right],
                 :border_width => 1,
                 :border_lines =>[:dashed, :dotted, :dotted, :dotted],
                 :border_color => "B2BEB5",}
               #  row(0).font_style = :bold  #for some reason this isnt working
                 columns(0..2).width = 100
                 columns(0..2).align = :center
                 rows(0).background_color = "D3D3D3"
                 rows(0).size = 7
                end
        pdf.move_down 20
        
        washsheet_detail_table_data = Array.new
        washsheet_detail_table_data << ["Product", "Whole Cheese Count", "Cheeses Washed", "Notes"]
          @picksheetitems_by_product.each do |product, picksheetitems|
            washsheet_detail_table_data  << [product, how_many_cheeses_do_i_need(product, picksheetitems).round(0), "", ""]
        end
        
        pdf.table(washsheet_detail_table_data) do 
          self.width = 450
           self.cell_style = { :inline_format => true, size:10 } 
           {:borders => [:top, :left, :bottom, :right],
           :border_width => 1,
           :border_lines =>[:dashed, :dotted, :dotted, :dotted],
           :border_color => "B2BEB5",}
         #  row(0).font_style = :bold  #for some reason this isnt working
           columns(0..2).width = 100
           columns(3).width = 150
           columns(0..3).align = :center
           rows(0).background_color = "D3D3D3"
            rows(0).size = 7
          end
            pdf.move_down 20
          
          signature_box = Array.new
          signature_box << ["Wash completed by:"]
          signature_box << [""]
          
          pdf.table(signature_box) do 
            self.width = 300
             self.cell_style = { :inline_format => true, size:10 } 
             {:borders => [:top, :left, :bottom, :right],
             :border_width => 1,
             :border_color => "B2BEB5",}
            columns(0).width = 300
            rows(0).background_color = "D3D3D3"
            rows(0).size = 7
            rows(1).height = 70
            end
       
       pdf.image logo_img_path, :at => [482,742], :width => 80 
       send_data pdf.render, filename: 'washsheet_pdf.pdf', type: 'application/pdf', :disposition => 'inline'
   
      
     end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wash
      @wash = Wash.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wash_params
      params.require(:wash).permit(:action_date, :wash_status, picksheet_ids: [])
    end
    
    def weight_of_whole_cheese(product)
      product_name = product
      Calculation.where(product: product_name, size: "Whole").pluck(:weight)
    end
   
    def get_weight_of_group(picksheet_items)
      picksheet_items.map(&:get_weight).sum 
    end
   
    # This takes input of ordered cheese weight (in kgs) and product name, 
    def how_many_cheeses_do_i_need(product, picksheet_items)
     
     weight_of_cheese_ordered_in_g = get_weight_of_group(picksheet_items)*1000
    
     weight_of_one_whole_cheese = weight_of_whole_cheese(product).first.to_i
    
     (weight_of_cheese_ordered_in_g.to_f/weight_of_one_whole_cheese.to_f).round(1) 
    end
end
