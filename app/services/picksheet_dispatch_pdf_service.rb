class PicksheetDispatchPdfService
  require 'prawn'

  def initialize(grouped_picksheets)
    @grouped_picksheets = grouped_picksheets
    @raleway_font_path = 'app/assets/fonts/raleway/Raleway-Medium.ttf'
    @raleway_bold_font_path = 'app/assets/fonts/raleway/Raleway-Bold.ttf'
    @logo_img_path = 'app/assets/images/poacher_logo.jpeg'
  end

  def generate
    pdf = Prawn::Document.new
    set_fonts(pdf)
    add_header(pdf)
    add_logo(pdf)
  
    # Initialize table data
    table_data = [["Pallet", "Number of Boxes", "Customer", "Notes"]]
  
    # Loop through grouped items
    @grouped_picksheets.each do |carrier, picksheets|
      # Set header background color based on carrier value
      header_background_color = case carrier
                                when 'Langdons'
                                  'FFFF99' # Light yellow for Langdons
                                when 'Palletline'
                                  'FFFF99' # A different color for Palletline
                                when 'Tim to Deliver'
                                  'A9B97E' # A different color for Tim
                                when 'Customer Collect'
                                  'A9B97E' # A different color for Customer Collect
                                when 'DPD by 12'
                                  'FFD700' # A different color for DPD by 12
                                else
                                  'E0E0E0' # Default light grey for other carriers
                                end
  
      # Add carrier as a bold row, spanning all columns, with dynamic background color
      table_data << [{ content: carrier, colspan: 4, font_style: :bold, background_color: header_background_color, align: :left }]
  
      # Loop through each picksheet for the current carrier
      picksheets.each do |picksheet|
        
        # Add the data row (with conditional background color)
        table_data << [
          "x",  # Placeholder for "Pallet"
          picksheet.number_of_boxes, 
          picksheet.contact.business_name, 
          picksheet.carrier_collection_notes
        ]
      end
    end
  
    # Add table to PDF
    pdf.table(table_data, width: 450, cell_style: { inline_format: true, size: 10 }) do |t|
      # Style the header row
      t.row(0).size = 7
      t.column(0).width = 50
      t.column(1).width = 50
      t.column(2).width = 150
      t.column(3).width = 200
      t.columns(0..1).align = :center
      t.columns(2..4).align = :left
    end
  
    # Return the raw PDF data
    pdf.render
  end
  
end
