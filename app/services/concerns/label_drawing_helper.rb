module LabelDrawingHelper
  def draw_label(pdf, makesheet)
    qr_data = Rails.application.routes.url_helpers.makesheet_url(makesheet, host: "http://localhost:3000")
    qrcode = RQRCode::QRCode.new(qr_data)

    pdf.stroke_bounds

    padding = 4.mm
    pdf.bounding_box([padding, pdf.bounds.top - padding], width: pdf.bounds.width - 2 * padding, height: pdf.bounds.height - 2 * padding) do
      left_width = 45.mm
      qr_width = 30.mm

      # === LEFT TEXT ===
      pdf.bounding_box([0, pdf.bounds.top], width: left_width, height: pdf.bounds.height) do
        pdf.text makesheet.make_date.strftime("%A"), size: 10
        pdf.text makesheet.make_date.strftime("%d/%m/%Y"), size: 12, style: :bold
        pdf.move_down 6

        pdf.stroke_horizontal_rule
        pdf.move_down 8

        pdf.text "Cheeses: #{makesheet.number_of_cheeses}", size: 10
        pdf.text "Weight: #{makesheet.total_weight} kg", size: 10
        pdf.move_down 6

        pdf.text "Time: #{makesheet.total_time}", size: 10
        pdf.text "Titration: #{makesheet.the_final_titration}", size: 10
        pdf.move_down 6

        pdf.text "Grade: #{makesheet.grade}", size: 10, style: :bold if makesheet.grade.present?
      end

      # === RIGHT QR ===
      pdf.bounding_box([left_width + 8.mm, pdf.bounds.top], width: qr_width, height: pdf.bounds.height) do
        qr_extent = 24.mm
        center_x = qr_width / 2
        center_y = pdf.bounds.height / 2

        pdf.stroke_circle [center_x, center_y], 14.mm

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
