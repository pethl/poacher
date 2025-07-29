require 'prawn'
require 'prawn/qrcode'

# === Constants ===
LABEL_WIDTH_MM = 89
LABEL_HEIGHT_MM = 41
PT_PER_MM = 2.83465
LABEL_WIDTH_PT = LABEL_WIDTH_MM * PT_PER_MM
LABEL_HEIGHT_PT = LABEL_HEIGHT_MM * PT_PER_MM

OUTPUT_PATH = "example_label.pdf"

Prawn::Document.generate(OUTPUT_PATH, page_size: [LABEL_WIDTH_PT, LABEL_HEIGHT_PT], margin: 0) do |pdf|
  pdf.font_size(12)

  # === QR Code ===
  pdf.render_qr_code("https://example.com", extent: 70, stroke: false, align: :left, valign: :top)

  # === Vertical Text (Rotated) ===
  pdf.rotate(90, origin: [0, 0]) do
    pdf.font_size(22)
    pdf.draw_text "Wednesday", at: [10, -10]
    pdf.draw_text "12-JAN-2025", at: [10, -40]
  end

  # === Right-side numbers ===
  pdf.font_size(14)
  base_x = LABEL_WIDTH_PT - 60
  top_y = LABEL_HEIGHT_PT - 60

  lines = [
    "605.8kg",
    "6.06...",
    "31",
    "0.55"
  ]

  lines.each_with_index do |line, i|
    pdf.draw_text line, at: [base_x, top_y - (i * 20)]
  end
end

puts "✅ Label saved to #{OUTPUT_PATH}"
