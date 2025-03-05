class PicksheetManifestPdfService
    require 'prawn'

  def initialize(grouped_items)
    @grouped_items = grouped_items

    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end


  def generate
    pdf = Prawn::Document.new
    set_fonts(pdf)
    add_header(pdf)
    add_logo(pdf)
      
     
      # Add table data
      table_data = [["Size", "Wedge Size", "Count", "Cutting Room Comment"]]

      # Loop through grouped items
        @grouped_items.each do |product, items|
          # Add product name as a separate row (bold and spanning all columns)
          table_data << [{ content: product, colspan: 4, font_style: :bold, background_color: 'E0E0E0', align: :left }]

          # Add the grouped items under the product
          items.each do |item|
            table_data << [ item[:size], item[:wedge_size], item[:count], ""]
          end
        end

        # Add table to PDF
        pdf.table(table_data, width: 400, cell_style: { inline_format: true, size: 10 }) do |t|
          # Style header row
          #t.row(0).background_color = 'D3D3D3'
          t.row(0).size = 7
          t.column(0).width = 100
          t.column(1).width = 100
          t.column(2).width = 50
          t.column(3).width = 150
          t.columns(0..3).align = :left
        end

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

