# app/services/concerns/label_drawing_helper.rb

require 'rqrcode'
require 'chunky_png'
require 'prawn/qrcode'
require 'rqrcode'
require 'chunky_png'
require 'prawn/qrcode'

module LabelDrawingHelper
  def draw_label(pdf, makesheet)
    qr_data = Rails.application.routes.url_helpers.makesheet_url(makesheet, host: "http://localhost:3000")
    qrcode = RQRCode::QRCode.new(qr_data)

    pdf.line_width = 0.5
    pdf.stroke_color = "000000"
    pdf.stroke_bounds

    padding = 2.mm
    inner_width = pdf.bounds.width - (2 * padding)
    inner_height = pdf.bounds.height - (2 * padding)

    pdf.bounding_box([padding, pdf.bounds.top - padding], width: inner_width, height: inner_height) do
      qr_box_width = 40.mm
      text_box_width = inner_width - qr_box_width - 10.mm

      # === LEFT BLOCK: Text ===
      pdf.bounding_box([0, pdf.bounds.top], width: text_box_width, height: pdf.bounds.height) do
        row_gap = 12
        col_width = 20.mm

        pdf.text makesheet.make_date.strftime("%A"), size: 10
        pdf.text makesheet.make_date.strftime("%d/%m/%Y"), size: 12, style: :bold
        pdf.move_down 4

        pdf.stroke_color "444444"
        rule_width = (col_width * 2) + 4.mm
        pdf.stroke do
          pdf.line [0, pdf.cursor], [rule_width, pdf.cursor]
        end
        pdf.stroke_color "000000"
        pdf.move_down 8

        row_y = pdf.cursor
        pdf.text_box "#{makesheet.number_of_cheeses}", at: [0, row_y], size: 10, width: col_width
        pdf.text_box "#{makesheet.total_weight} kg", at: [col_width, row_y], size: 10, width: col_width
        pdf.move_down row_gap

        row_y = pdf.cursor
        pdf.text_box "#{makesheet.total_minutes}", at: [0, row_y], size: 10, width: col_width
        pdf.text_box "#{makesheet.final_titration}", at: [col_width, row_y], size: 10, width: col_width
        pdf.move_down row_gap + 4

        if makesheet.grade.present?
          pdf.move_down 2
          pdf.text makesheet.grade, size: 10, style: :bold, align: :left
        end
      end

      # === RIGHT BLOCK: QR in Circle ===
      pdf.bounding_box([text_box_width + 17.mm, pdf.bounds.top], width: qr_box_width, height: pdf.bounds.height) do
        qr_extent = 22.mm
        circle_radius = 14.mm

        center_x = qr_box_width / 2
        center_y = pdf.bounds.height / 2

        pdf.stroke_color '000000'
        pdf.line_width = 1
        pdf.stroke_circle [center_x, center_y], circle_radius

        pdf.bounding_box(
          [center_x - qr_extent / 2, center_y + qr_extent / 2],
          width: qr_extent,
          height: qr_extent
        ) do
          pdf.render_qr_code(qrcode, extent: qr_extent, stroke: false)
        end
      end
    end
  end
end
