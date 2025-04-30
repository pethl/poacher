class PicksheetManifestPdfService
    require 'prawn'

  def initialize(grouped_items, product_names, product_to_business_names)
      @grouped_items = grouped_items
      @product_names = product_names
      @product_to_business_names = product_to_business_names
    

    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end


  def generate
    pdf = Prawn::Document.new
    set_fonts(pdf)
    add_header(pdf)
    add_logo(pdf)
          
    # Table 1
    add_grouped_items_table(pdf)

    # Table 2
    add_customers_per_product_table(pdf)

    # Return raw PDF data
      pdf.render
    end
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
    pdf.text 'Daily Cheese Manifest', size: 14, style: :bold, align: :left
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}\n", size: 6, align: :left
    pdf.move_down 8
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

    def add_grouped_items_table(pdf)
      pdf.move_down 20
      table_data = [["Size", "Wedge Size", "Count", "Cutting Room Comment"]]
    
      @grouped_items.each do |product, items|
        table_data << [{ content: product, colspan: 4, font_style: :bold, background_color: 'E0E0E0', align: :left }]
        items.each do |item|
          table_data << [item[:size], item[:wedge_size], item[:count], ""]
        end
      end
    
      pdf.table(table_data, width: 400, cell_style: { inline_format: true, size: 10 }) do |t|
        t.row(0).size = 7
        t.column(0).width = 100
        t.column(1).width = 100
        t.column(2).width = 50
        t.column(3).width = 150
        t.columns(0..3).align = :left
      end
    end

    def add_customers_per_product_table(pdf)
      pdf.move_down 30
      pdf.text "Customers Per Product", size: 12, style: :bold
      pdf.move_down 8
    
      # Build header row
      header = @product_names.map(&:upcase)
    
      # Determine max number of rows
      max_rows = @product_names.map { |p| @product_to_business_names[p].size }.max
    
      # Build row data
      body_rows = (0...max_rows).map do |i|
        @product_names.map { |p| @product_to_business_names[p][i] || "" }
      end
    
      # Combine header + body
      table_data = [header] + body_rows
    
      # Add table
      pdf.table(table_data, cell_style: { size: 8 }, width: pdf.bounds.width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "F0F0F0"
        t.row(0).size = 9
      end
    end
    

