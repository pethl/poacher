# frozen_string_literal: true

require 'prawn'
require 'prawn/measurement_extensions'
require 'prawn/qrcode'
include Prawn::Measurements

class CheeseSingleLabelService
  def initialize(makesheet)
    @makesheet = makesheet
  end

  def generate
    url = Rails.application.routes.url_helpers.makesheet_url(@makesheet, host: "http://localhost:3000")
    qrcode = RQRCode::QRCode.new(url)

    pdf = Prawn::Document.new(page_size: [41.mm, 89.mm], margin: 0.mm)

    center_x = pdf.bounds.width / 2
    center_y = pdf.bounds.height / 2

    pdf.rotate(90, origin: [center_x, center_y]) do
      pdf.bounding_box([center_x - (pdf.bounds.height / 2), center_y + (pdf.bounds.width / 2)],
                       width: pdf.bounds.height,
                       height: pdf.bounds.width) do

        scale_factor = 0.81
        inner_width = pdf.bounds.width * scale_factor
        inner_height = pdf.bounds.height * scale_factor

        if inner_width > inner_height
          inner_width *= 1.10
        else
          inner_height *= 1.10
        end

        origin_x = (pdf.bounds.width - inner_width) / 2
        origin_y = pdf.bounds.height - ((pdf.bounds.height - inner_height) / 2)

        pdf.bounding_box([origin_x, origin_y], width: inner_width, height: inner_height) do
          margin = 4.mm
          qr_extent = 22.mm

          text_x = margin
          text_width = pdf.bounds.width - qr_extent - 3 * margin
          label_text = @makesheet.make_date.strftime("%d-%b-%Y").upcase

          pdf.text_box label_text,
                       size: 12,
                       at: [text_x, pdf.bounds.height - margin],
                       width: text_width,
                       height: 30.mm,
                       overflow: :shrink_to_fit,
                       min_font_size: 6,
                       align: :left,
                       valign: :center

          qr_x = pdf.bounds.width - qr_extent - margin
          qr_y = pdf.bounds.height - margin

          pdf.bounding_box([qr_x, qr_y], width: qr_extent, height: qr_extent) do
            pdf.render_qr_code(qrcode, extent: qr_extent, stroke: false)
          end
        end
      end
    end

    pdf.render
  end

  def print
    Tempfile.create(['cheese_label', '.pdf']) do |file|
      file.binmode
      file.write(generate)
      file.flush

      system("/usr/bin/lp",
             "-o", "PageSize=Custom.41x89mm",
             "-o", "fit-to-page=false",
             "-o", "scaling=100",
             "-d", "_650",
             file.path)
    end
  end
end
