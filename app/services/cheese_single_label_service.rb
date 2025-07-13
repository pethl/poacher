require 'prawn'
require 'prawn/measurement_extensions'
require 'tempfile'
require_relative './concerns/label_drawing_helper'


class CheeseSingleLabelService
  include LabelDrawingHelper

  def initialize(makesheet)
    @makesheet = makesheet
  end

  def generate
    pdf = Prawn::Document.new(page_size: [90.mm, 40.mm], margin: 4.mm)

    pdf.font_families.update(
      "DejaVu" => {
        normal: Rails.root.join("app/assets/fonts/DejaVuSans.ttf"),
        bold:   Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf")
      }
    )
    pdf.font "DejaVu"

    pdf.line_width = 0.5
    pdf.stroke_color = "000000"
    pdf.stroke_bounds

    draw_label(pdf, @makesheet)

    pdf.render
  end
end

