require 'prawn'
require 'prawn/measurement_extensions'

class AisleMarkerPdfService
  def initialize(locations)
    @locations = locations
  end

  def generate
    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, margin: 0)

    pdf.font_families.update(
      "DejaVu" => {
        normal: Rails.root.join("app/assets/fonts/DejaVuSans.ttf"),
        bold:   Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf")
      }
    )
    pdf.font "DejaVu"

    # Marker size: 2cm smaller than A5 on all sides
    marker_width  = 118.mm
    marker_height = 180.mm

    page_width  = 297.mm
    page_height = 210.mm

    horizontal_spacing = (page_width - (2 * marker_width)) / 3.0
    vertical_margin    = (page_height - marker_height) / 2.0

    @locations.each_slice(2).with_index do |pair, page_index|
      pair.each_with_index do |location, i|
        x = horizontal_spacing + i * (marker_width + horizontal_spacing)
        y = page_height - vertical_margin

        pdf.bounding_box([x, y], width: marker_width, height: marker_height) do
          pdf.stroke_bounds
          draw_marker(pdf, location)
        end
      end

      pdf.start_new_page unless page_index == (@locations.size - 1) / 2
    end

    pdf.render
  end

  private

  def draw_marker(pdf, location)
    shed         = location.name[/Shed\s\d+/i]&.upcase || "SHED"
    aisle_number = location.name[/Aisle\s(\d+)/i, 1] || "?"
    side         = location.name[/\b(Left|Right)\b/i]&.capitalize || ""
  
    # Reversed arrow direction
    arrow = case side
            when "Left"  then "→"
            when "Right" then "←"
            else ""
            end
  
    pdf.font "DejaVu"
  
    # Layout estimates for vertical centering
    content_height = 32 + 40 + +20+20 +88 + 30 + 32
    box_height = pdf.bounds.height
    start_offset = (box_height - content_height) / 2.0
  
    pdf.move_down start_offset
  
    pdf.text shed, align: :center, size: 32, style: :bold
    pdf.move_down 40
    pdf.text "Aisle", align: :center, size: 20, style: :bold
    pdf.move_down 20
  
    pdf.text aisle_number.to_s, align: :center, size: 88, style: :bold
    pdf.move_down 30
  
    pdf.text side.upcase, align: :center, size: 32, style: :bold
    pdf.move_down 6
  
    pdf.text arrow, align: :center, size: 32, style: :bold
  end
  
end



