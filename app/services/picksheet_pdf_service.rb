class PicksheetPdfService
  require 'prawn'

  def initialize(picksheet)
    @picksheet = picksheet
    @picksheet_items = picksheet.picksheet_items

    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end
 
  def generate
    pdf = Prawn::Document.new
    set_fonts(pdf)
    add_header(pdf)
    add_picksheet_details(pdf)
    add_picksheet_items(pdf)
    add_logo(pdf)

    pdf.render
  end

  private

  def set_fonts(pdf)
    pdf.font_families.update(
      'raleway' => {
        normal: @raleway_font_path,
        bold: @raleway_bold_font_path
      }
    )
    pdf.font 'raleway'
  end

  def add_header(pdf)
    pdf.text 'Picking Sheet', size: 14, style: :bold, align: :left
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}\n", size: 6, align: :left
    pdf.move_down 8
  end

  def add_picksheet_details(pdf)
    notes_text = @picksheet.carrier_collection_notes.to_s.strip

    picksheet_header_table_data = [
      ["Date Order Placed:", format_date(@picksheet.date_order_placed), "Customer:", customer_details],
      ["Delivery Required By:", @picksheet.full_delivery_info, "Contact Telephone:", @picksheet.contact_telephone_number.to_s],
      ["Order Number:", @picksheet.order_number, "Invoice Number:", @picksheet.invoice_number],
      ["", "", "Carrier:", @picksheet.carrier],
      ["No of Boxes:", @picksheet.number_of_boxes.to_s.presence, "Carrier Delivery Date:", format_date(@picksheet.carrier_delivery_date)],
      ["Carrier/Cust Collection Notes", { content: (notes_text.presence || ""), colspan: 3 }]
    ]

    pdf.table(picksheet_header_table_data, width: 460, cell_style: { inline_format: true, size: 10 }) do |t|
      # widths / alignment
      t.column(0).width = 110
      t.column(1).width = 120
      t.column(2).width = 110
      t.column(3).width = 120
  
      t.column(0).align = :right
      t.column(1).align = :center
      t.column(2).align = :right
      t.column(3).align = :center
  
      # label styling
      t.column(0).background_color = 'D3D3D3'
      t.column(2).background_color = 'D3D3D3'
      t.column(0).size = 7
      t.column(2).size = 7
  
      # ---- overrides for the LAST row (notes) ----
      # remove grey bg from merged cell (cols 1..3), left-align, add padding
      t.row(-1).columns(1..3).background_color = nil
      t.row(-1).columns(1..3).align = :left
      t.row(-1).columns(1..3).padding = [6, 8, 6, 8]
      # keep the label cell (col 0) styled as normal; optional smaller font:
      t.row(-1).column(0).size = 7
    end
    pdf.move_down 16
  end

 

  def add_picksheet_items(pdf)
    picksheet_item_table_data = [["Product", "Size", "Pricing", "Count", "Weight(kg)", "Code", "Sp Price", "B/B Date"]]

    @picksheet_items.each do |item|
      size_with_wedge = item.wedge_size.present? ? "#{item.size}\n#{item.wedge_size}" : item.size

      picksheet_item_table_data << [
        item.product, 
        size_with_wedge, 
        item.pricing,
        item.count, 
        item.weight, 
        item.code, 
        item.sp_price, 
        format_date(item.bb_date)
  ]
    end

    pdf.table(picksheet_item_table_data, width: 510, cell_style: { inline_format: true, size: 10 }) do |t|
      t.row(0).background_color = 'D3D3D3'
      t.row(0).size = 7
      t.column(0).width = 84
      t.column(1).width = 84
      t.column(2).width = 70
      t.column(3).width = 30
      t.column(4).width = 60
      t.column(5).width = 60
      t.column(6).width = 60
      t.column(7).width = 62
      t.columns(1..4).align = :center
      t.column(5..7).align = :right
    end
  end

  def add_logo(pdf)
    pdf.image @logo_img_path, at: [482, 742], width: 80
  end

  def format_date(date)
    date.present? ? date.strftime('%b %d, %Y') : ''
  end

  def customer_details
    [@picksheet.contact&.business_name, @picksheet.contact&.contact_name].compact.join("\n")
  end
end
