require 'prawn'
require 'prawn/qrcode'
require 'rqrcode'

LABEL_WIDTH_MM = 89
LABEL_HEIGHT_MM = 41
PT_PER_MM = 2.83465
WIDTH_PT = LABEL_WIDTH_MM * PT_PER_MM
HEIGHT_PT = LABEL_HEIGHT_MM * PT_PER_MM

OUTPUT_PATH = "example_label.pdf"

Prawn::Document.generate(OUTPUT_PATH, page_size: [WIDTH_PT, HEIGHT_PT], margin: 0) do |pdf|
  # === QR Code ===
  qr = RQRCode::QRCode.new("https://example.com")
  qr_size = 100
  qr_margin = 10
  pdf.bounding_box([qr_margin, HEIGHT_PT - qr_margin], width: qr_size, height: qr_size) do
    pdf.render_qr_code(qr, extent: qr_size, stroke: false)
  end

  # === Right-side Text ===
  label_x = WIDTH_PT - 120     # left value
  value_x = WIDTH_PT - 70      # right value
  top_y = HEIGHT_PT - 24       # starting Y

  # Day & Date
  pdf.font_size(10)
  pdf.draw_text "Wednesday", at: [label_x, top_y]
  pdf.font_size(16)
  pdf.draw_text "12-JAN-2025", at: [label_x, top_y - 20]
  
  # Underline under the date
  line_start_x = label_x
  line_end_x = label_x + 100  # Adjust width as needed
  line_y = top_y - 25        # Slightly below the date text

  pdf.stroke_color "000000"  # Optional: set color
  pdf.stroke_line [line_start_x, line_y], [line_end_x, line_y]

  # Values (two per line)
  lines = [
    ["31", "605.8kg"],
    ["0.55", "6.06"]
  ]

  pdf.font_size(10)
  start_y = top_y - 56

  lines.each_with_index do |(left, right), i|
    y = start_y - (i * 15)
    pdf.draw_text left, at: [label_x, y]
    pdf.draw_text right, at: [value_x, y]
  end
end

puts "✅ Label saved to #{OUTPUT_PATH}"
