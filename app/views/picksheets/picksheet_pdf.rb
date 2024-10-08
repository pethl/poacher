class PicksheetPdf < Prawn::Document
  
  
  def print_picksheet_pdf(id) 
 
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
    
    @start_date = Date.today.beginning_of_year # Current vacation calendar year
    @picksheet = Picksheet.find(id)
    @picksheet_items = PicksheetItem.where(picksheet_id: @picksheet.id)
    
    
    # pdf.text " ..:: LINCOLNSHIRE POACHER ::.. "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 10, align: :center
     pdf.text "Picking Sheet", size: 14, style: :bold, align: :left
     pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y')+"\n", size: 6, align: :left
     pdf.text "\n", size: 6  

     picksheet_header_table_data = Array.new
     picksheet_header_table_data << ["Date Order Placed", @picksheet.date_order_placed.to_datetime.strftime('%b %d, %Y'), "Customer", "Fake Name"]
     picksheet_header_table_data << ["Delivery Required By", @picksheet.delivery_required_by.to_datetime.strftime('%b %d, %Y'), "Contact Telephone", @picksheet.contact_telephone_number.to_s]
     picksheet_header_table_data << ["Order Number", @picksheet.order_number, "Invoice Number", @picksheet.invoice_number]
     picksheet_header_table_data << ["","","Carrier", @picksheet.carrier]
     picksheet_header_table_data << ["No of Boxes", @picksheet.number_of_boxes.to_s, "Carrier Delivery Date", @picksheet.carrier_delivery_date.to_datetime.strftime('%b %d, %Y')]
  
            pdf.table(picksheet_header_table_data) do 
               self.width = 360
               self.cell_style = { :inline_format => true, size: 6 } 
               {:borders => [:top, :left, :bottom, :right],
               :border_width => 1,
               :border_color => "B2BEB5"}
             #  row(0).font_style = :bold
               columns(0).width = 90
               columns(1).width = 90
               columns(2).width = 90
               columns(3).width = 90
               columns(0).align = :right
               columns(1).align = :left
               columns(2).align = :right
               columns(3).align = :left
               columns(0).background_color = "D3D3D3"
               columns(2).background_color = "D3D3D3"
             end
           pdf.text "\n", size: 6  
           pdf.text "\n", size: 6  
       
        picksheet_item_table_data = Array.new
        picksheet_item_table_data << ["Product", "Size", "Count", "Weight", "Code", "Sp Price", "B/B Date"]
        @picksheet_items.each do |item|
           picksheet_item_table_data << [item.product, item.size, item.count, item.weight, item.code, item.sp_price, item.bb_date]
        end
        pdf.table(picksheet_item_table_data) do 
           self.width = 420
           self.cell_style = { :inline_format => true, size: 6 } 
           {:borders => [:top, :left, :bottom, :right],
           :border_width => 1,
           :border_color => "B2BEB5"}
           row(0).background_color = "D3D3D3"
           columns(0).width = 60
           columns(1).width = 60
           columns(2).width = 60
           columns(3).width = 60
           columns(4).width = 60
           columns(5).width = 60
           columns(6).width = 60
           columns(1).align = :center
           columns(2).align = :center
           columns(3).align = :center
           columns(4).align = :center
         end
         pdf.image logo_img_path, :at => [462,737], :width => 80 
         send_data pdf.render, filename: 'picking_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
       
  end
  
end