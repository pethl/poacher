require 'prawn'
require 'prawn/measurement_extensions'

class AisleMarkerPdfService
  def initialize(locations)
    @locations = locations
  end

  def generate
    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :portrait, margin: 0)

    pdf.font_families.update(
      "DejaVu" => {
        normal: Rails.root.join("app/assets/fonts/DejaVuSans.ttf"),
        bold:   Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf")
      }
    )
    pdf.font "DejaVu"

    # Full page dimensions and outer margins
    outer_margin_x = 20.mm
    outer_margin_y = 20.mm

    page_width  = 210.mm
    page_height = 297.mm

    printable_width  = page_width - (2 * outer_margin_x)  # 170 mm
    printable_height = page_height - (2 * outer_margin_y) # 257 mm

    spacing_x = 10.mm
    spacing_y = 10.mm

    columns = 2
    rows = 2

    marker_width  = (printable_width  - spacing_x) / columns  # 80 mm
    marker_height = (printable_height - spacing_y) / rows     # 123.5 mm

    @locations.each_slice(4).with_index do |page_locations, page_index|
      page_locations.each_with_index do |location, i|
        col = i % columns
        row = i / columns

        x = outer_margin_x + col * (marker_width + spacing_x)
        y = page_height - outer_margin_y - row * (marker_height + spacing_y)

        pdf.bounding_box([x, y], width: marker_width, height: marker_height) do
          pdf.stroke_bounds
          draw_marker(pdf, location)
        end
      end

      pdf.start_new_page unless page_index == (@locations.size - 1) / 4
    end

    pdf.render
  end

  private

  def draw_marker(pdf, location)
    shed         = location.name[/Shed\s\d+/i]&.upcase || "SHED"
    aisle_number = location.name[/Aisle\s(\d+)/i, 1] || "?"
    side         = location.name[/\b(Left|Right)\b/i]&.capitalize || ""
  
    # Reverse arrow direction: Left = →, Right = ←
    arrow_direction = side == "Left" ? "right" : side == "Right" ? "left" : nil
    arrow_filename = "#{arrow_direction}-long-solid.png" if arrow_direction
    arrow_path = arrow_filename ? Rails.root.join("app/assets/images", arrow_filename) : nil
  
    pdf.font "DejaVu"
  
    pdf.move_down 40
    pdf.text shed, align: :center, size: 18, style: :bold
    pdf.move_down 24
  
    pdf.text "Aisle", align: :center, size: 12, style: :bold
    pdf.move_down 10
  
    pdf.text aisle_number.to_s, align: :center, size: 80, style: :bold
    pdf.move_down 14
  
    pdf.text side.upcase, align: :center, size: 16, style: :bold
    pdf.move_down 6
  
    # Insert arrow image if it exists
    if arrow_path && File.exist?(arrow_path)
      pdf.image arrow_path, width: 20.mm, position: :center
    else
      # Fallback if image not found
      pdf.text "(arrow)", align: :center, size: 10, color: "888888"
    end
  end
  
end

