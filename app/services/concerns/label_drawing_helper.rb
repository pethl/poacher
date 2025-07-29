# app/helpers/label_drawing_helper.rb
module LabelDrawingHelper
  def draw_label(pdf, makesheet)

    label_width_mm  = 89
    label_height_mm  = 41
    pt_per_mm  = 2.83465
    width_pt = label_width_mm * pt_per_mm
    height_pt = label_height_mm * pt_per_mm

    qr_data = Rails.application.routes.url_helpers.makesheet_url(makesheet, host: "http://localhost:3000")
    qrcode = RQRCode::QRCode.new(qr_data)
    qr_size = 100
    qr_margin = 10
    pdf.bounding_box([qr_margin, height_pt - qr_margin], width: qr_size, height: qr_size) do
      pdf.render_qr_code(qrcode, extent: qr_size, stroke: false)
    end
    

    # full_width = pdf.bounds.width
    # full_height = pdf.bounds.height
    # padding = 15

    # Split the space into left text area and right QR area
    # text_width = full_width * 0.55
    # qr_width = full_width - text_width

    
    # === Right-side Text ===
  label_x = width_pt - 120     # left value
  value_x = width_pt - 70      # right value
  top_y = height_pt - 24       # starting Y

  # Day & Date
  pdf.font_size(10)
  pdf.draw_text makesheet.make_date.strftime("%A"), at: [label_x, top_y]
  pdf.font "Helvetica-Bold"  # <-- switch to bold
  pdf.font_size(16)
  pdf.draw_text makesheet.make_date.strftime("%d-%b-%Y").upcase, at: [label_x, top_y - 20]
  pdf.font "Helvetica"       # <-- reset to regular for other text
  # Underline under the date
  line_start_x = label_x
  line_end_x = label_x + 100  # Adjust width as needed
  line_y = top_y - 25        # Slightly below the date text

  pdf.stroke_color "000000"  # Optional: set color
  pdf.stroke_line [line_start_x, line_y], [line_end_x, line_y]

  # Values (two per line)
  lines = [
        [makesheet.number_of_cheeses.to_s, "#{makesheet.total_weight}kg"],
        [makesheet.the_final_titration.to_s, makesheet.total_time.to_s]
      ]

  pdf.font_size(12)
  start_y = top_y - 56

  lines.each_with_index do |(left, right), i|
    y = start_y - (i * 15)
    pdf.draw_text left, at: [label_x, y]
    pdf.draw_text right, at: [value_x, y]
  end
   
 end
end
