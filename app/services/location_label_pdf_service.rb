class LocationLabelPdfService
  require 'prawn'
  require 'prawn/measurement_extensions'
  require 'prawn/qrcode'

  def initialize(location_data)
    @location_data = location_data  # array of { location:, url: }
  end

  def generate
    pdf = Prawn::Document.new(page_size: 'A4', margin: 0)

    # Embed UTF-8-compatible font
    pdf.font_families.update(
      "DejaVu" => {
        normal: Rails.root.join("app/assets/fonts/DejaVuSans.ttf"),
        bold:   Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf")
      }
    )
    pdf.font "DejaVu"

    gap_x = 20.mm
    gap_y = 20.mm
    margin_x = 10.mm
    margin_y = 5.mm

    label_width = (210.mm - (2 * margin_x) - gap_x) / 2.0
   
    label_height = (297.mm - (2 * margin_y) - gap_y) / 2.0


    @location_data.each_slice(4).with_index do |page_locations, page_index|
      page_locations.each_with_index do |entry, i|
        location = entry[:location]
        url = entry[:url]

        col = i % 2
        row = i / 2

        x = margin_x + col * (label_width + gap_x)
        y = pdf.bounds.top - margin_y - row * (label_height + gap_y)

        pdf.bounding_box([x, y], width: label_width, height: label_height) do
          pdf.stroke_bounds
          draw_label(pdf, location, url)
        end
      end

      pdf.start_new_page unless page_index == (@location_data.size - 1) / 4
    end

    pdf.render
  end

  private

  def draw_label(pdf, location, url)
    qrcode = RQRCode::QRCode.new(url)
  
    qr_extent = 35.mm
    qr_padding = 2.mm
    qr_box_width = qr_extent + (qr_padding * 2)
  
    top_half_height = pdf.bounds.height / 2
    full_content_width = pdf.bounds.width - qr_box_width - 6.mm
  
    pdf.bounding_box([0, pdf.bounds.top], width: pdf.bounds.width, height: top_half_height) do
      # QR Code
      pdf.bounding_box([-2.mm, top_half_height], width: qr_box_width, height: qr_extent + qr_padding * 2) do
        pdf.render_qr_code(qrcode, extent: qr_extent, stroke: false, align: :center)
      end
  
      if location.location_type == "Trolley"
        number = location.name.match(/\d+/)&.to_s
  
        pdf.bounding_box([qr_box_width + 4.mm, top_half_height], width: full_content_width, height: qr_extent + qr_padding * 2) do
          pdf.move_down (qr_extent / 4)
          pdf.text "Trolley", size: 16, style: :bold, align: :center
          pdf.move_down 5
          pdf.text number.to_s, size: 54, style: :bold, align: :center
        end
  
      else
        shed_number  = location.name.match(/Shed (\d+)/)&.captures&.first.to_s
        aisle_number = location.name.match(/Aisle (\d+)/)&.captures&.first.to_s
        side         = location.name.include?("Left") ? "Left" : "Right"
        col          = location.name.match(/Col (\d+)/)&.captures&.first.to_i
  
        arrow_direction =
          if side == "Left"
            col.odd? ? "left" : "right"
          else
            col.odd? ? "right" : "left"
          end

        arrow_filename = "#{arrow_direction}-long-solid.png"
        arrow_path = Rails.root.join("app/assets/images", arrow_filename)
  
        left_width  = full_content_width * 0.35
        right_width = full_content_width * 0.65
  
        # Left: shed/aisle/side text + arrow
        pdf.bounding_box([qr_box_width + 2.mm, top_half_height], width: left_width, height: qr_extent + qr_padding * 2) do
          pdf.move_down 10
          pdf.text "Shed #{shed_number}",  size: 10, style: :bold, align: :left
          pdf.text "Aisle #{aisle_number}", size: 10, style: :bold, align: :left
          pdf.text side,                   size: 10, style: :bold, align: :left
          pdf.move_down 6
  
          if File.exist?(arrow_path)
            pdf.image arrow_path, width: 12.mm, position: :left
          else
            pdf.text "→", size: 14, style: :bold, align: :left
          end
        end
  
        # Right: column number only
        pdf.bounding_box([qr_box_width + 2.mm + left_width, top_half_height], width: right_width, height: qr_extent + qr_padding * 2) do
          pdf.move_down 10
          begin
            pdf.text col.to_s, size: 50, style: :bold, align: :center
          rescue Prawn::Errors::CannotFit
            pdf.text col.to_s, size: 36, style: :bold, align: :center
          end
        end
      end
  
      pdf.move_down 6
      pdf.stroke_horizontal_rule
    end
  end
  
end
