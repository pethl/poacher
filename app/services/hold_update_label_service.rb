# app/services/hold_update_label_service.rb

require "prawn"
require "prawn/measurement_extensions"

class HoldUpdateLabelService
  def initialize(makesheet)
    @makesheet = makesheet
  end

  def generate
    pdf = Prawn::Document.new(
      page_size: [41.mm, 89.mm],
      margin: 0.mm
    )

    pdf.text "HOLD UPDATE LABEL"

    pdf.render
  end
end