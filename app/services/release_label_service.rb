# app/services/release_label_service.rb
# frozen_string_literal: true

require "prawn"
require "prawn/measurement_extensions"

class ReleaseLabelService
  def initialize(makesheet)
    @makesheet = makesheet
  end

  def generate
    pdf = Prawn::Document.new(
      page_size: [41.mm, 89.mm],
      margin: 0.mm
    )

    center_x = pdf.bounds.width / 2
    center_y = pdf.bounds.height / 2

    pdf.rotate(90, origin: [center_x, center_y]) do
      pdf.bounding_box(
        [center_x - (pdf.bounds.height / 2), center_y + (pdf.bounds.width / 2)],
        width: pdf.bounds.height,
        height: pdf.bounds.width
      ) do
        pdf.indent(8) do
          pdf.move_down 10

          pdf.fill_color "555555"
          pdf.text "RELEASE FROM HOLD",
                   size: 20,
                   style: :bold,
                   align: :left

          pdf.move_down 12

          pdf.fill_color "000000"

          pdf.formatted_text([
            { text: "Make Date: ", size: 10 },
            {
              text: @makesheet.make_date&.strftime("%a %d-%b-%Y").to_s,
              size: 12,
              styles: [:bold]
            }
          ])

          pdf.move_down 6

          reason =
            if @makesheet.metal_contamination?
              "Metal Contamination"
            elsif @makesheet.slow_cheese?
              "SLOW at make"
            else
              "–"
            end

          pdf.formatted_text([
            { text: "Reason: ", size: 10 },
            { text: reason, size: 12, styles: [:bold] }
          ])

          if @makesheet.slow_cheese?
            pdf.move_down 4
            pdf.fill_color "555555"
            pdf.text "STAPHS OK",
                     size: 8,
                     style: :bold,
                     align: :left
          end

          pdf.move_down 8

          pdf.fill_color "666666"
          pdf.formatted_text([
            { text: "Printed at: ", size: 8 },
            {
              text: Date.current.strftime("%d-%b-%Y"),
              size: 8,
              styles: [:bold]
            }
          ])
        end
      end
    end

    pdf.render
  end
end