# app/services/hold_label_service.rb

require "prawn"
require "prawn/measurement_extensions"

class HoldLabelService
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

          pdf.fill_color "FF0000"
          pdf.text "HOLD", size: 28, style: :bold, align: :left

          pdf.move_down 12

          pdf.fill_color "000000"
          pdf.formatted_text([
          { text: "Make Date: ", size: 12 },
          { text: @makesheet.make_date&.strftime("%a %d-%b-%Y").to_s,
            size: 12,
            styles: [:bold] }
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
            { text: "Reason: ", size: 12 },
            { text: reason,
              size: 12,
              styles: [:bold] }
            ])

            if @makesheet.metal_contamination?
            pdf.move_down 4

            pdf.fill_color "AA0000"

            pdf.text "ONLY TO BE RELEASED BY TIM",
                    size: 7,
                    style: :bold,
                    align: :left
          end

            pdf.move_down 6

          pdf.fill_color "666666"
          
          pdf.formatted_text([
              { text: "Printed at: ", size: 6 },
              { text: Date.current.strftime("%d-%b-%Y"),
                size: 6 }
            ])
        end
      end
  end

  pdf.render
end
end