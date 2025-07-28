require 'prawn'
require 'prawn/measurement_extensions'
require 'prawn/qrcode'
require 'rqrcode'
include Prawn::Measurements

# Load your real Makesheet here
makesheet = Makesheet.find(6256)

# Generate QR code from the real makesheet URL
url = Rails.application.routes.url_helpers.makesheet_url(makesheet, host: "http://localhost:3000")
qrcode = RQRCode::QRCode.new(url)

path = "tmp/manual_test_label.pdf"

Prawn::Document.generate(path, page_size: [41.mm, 89.mm], margin: 0.mm) do
  center_x = bounds.width / 2
  center_y = bounds.height / 2

  rotate(90, origin: [center_x, center_y]) do
    bounding_box([center_x - (bounds.height / 2), center_y + (bounds.width / 2)],
                 width: bounds.height,
                 height: bounds.width) do

      scale_factor = 0.81
      inner_width = bounds.width * scale_factor
      inner_height = bounds.height * scale_factor

      if inner_width > inner_height
        inner_width *= 1.10
      else
        inner_height *= 1.10
      end

      origin_x = (bounds.width - inner_width) / 2
      origin_y = bounds.height - ((bounds.height - inner_height) / 2)

      bounding_box([origin_x, origin_y], width: inner_width, height: inner_height) do
        margin = 4.mm
        qr_extent = 22.mm

        text_x = margin
        text_width = bounds.width - qr_extent - 3 * margin

        # Use the makesheet date as dynamic text
        label_text = makesheet.make_date.strftime("%d-%b-%Y").upcase

        text_box label_text,
                 size: 12,
                 at: [text_x, bounds.height - margin],
                 width: text_width,
                 height: 30.mm,
                 overflow: :shrink_to_fit,
                 min_font_size: 6,
                 align: :left,
                 valign: :center

        qr_x = bounds.width - qr_extent - margin
        qr_y = bounds.height - margin

        bounding_box([qr_x, qr_y], width: qr_extent, height: qr_extent) do
          render_qr_code(qrcode, extent: qr_extent, stroke: false)
        end
      end
    end
  end
end

puts "Saved to #{path}"

system("/usr/bin/lp",
       "-o", "PageSize=Custom.41x89mm",
       "-o", "fit-to-page=false",
       "-o", "scaling=100",
       "-d", "_650",
       path)
