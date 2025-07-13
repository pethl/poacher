require 'prawn'
require 'prawn/measurement_extensions'
require_relative './concerns/label_drawing_helper'

class CheeseMultiLabelService
  include LabelDrawingHelper

  def initialize(makesheets)
    @makesheets = makesheets
  end

  def generate
    pdf = Prawn::Document.new(page_size: 'A4', margin: 10.mm)

    # Match font with single label
    pdf.font_families.update(
      "DejaVu" => {
        normal: Rails.root.join("app/assets/fonts/DejaVuSans.ttf"),
        bold:   Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf")
      }
    )
    pdf.font "DejaVu"

    # Layout: 2 cols × 4 rows = 8 labels per page
      label_width  = 90.mm
      label_height = 40.mm
      h_gap = 6.mm
      v_gap = 6.mm

      labels_per_row = 2
      labels_per_col = 6

      @makesheets.each_slice(labels_per_row * labels_per_col).with_index do |sheet_batch, page_index|
        pdf.start_new_page unless page_index == 0

        sheet_batch.each_with_index do |makesheet, i|
          col = i % labels_per_row
          row = i / labels_per_row

          x = col * (label_width + h_gap)
          y = pdf.bounds.top - row * (label_height + v_gap)

          pdf.bounding_box([x, y], width: label_width, height: label_height) do
            draw_label(pdf, makesheet)
          end
        end
      end

    pdf.render
  end
end

