# app/services/cheese_single_label_service.rb
# frozen_string_literal: true

require 'prawn'
require 'prawn/qrcode'
require 'prawn/measurement_extensions'
include Prawn::Measurements

class CheeseSingleLabelService
  include LabelDrawingHelper

  def initialize(makesheet)
    @makesheet = makesheet
  end

  def generate
    pdf = Prawn::Document.new(
      page_size: [41.mm, 89.mm], # Portrait label
      margin: 0.mm
    )

    center_x = pdf.bounds.width / 2
    center_y = pdf.bounds.height / 2

    pdf.rotate(90, origin: [center_x, center_y]) do
      pdf.bounding_box([center_x - (pdf.bounds.height / 2), center_y + (pdf.bounds.width / 2)],
                       width: pdf.bounds.height,
                       height: pdf.bounds.width) do
        draw_label(pdf, @makesheet)
      end
    end

    pdf.render
  end

  def print
    Tempfile.create(['cheese_label', '.pdf']) do |file|
      file.binmode
      file.write(generate)
      file.flush
  
      printer_name = Current.user.label_printer_name

      raise "No label printer configured for #{Current.user.email}" if printer_name.blank?

      cmd = [
        "/usr/bin/lp",
        "-o", "PageSize=Custom.41x89mm",
        "-o", "fit-to-page=false",
        "-o", "scaling=100",
        "-o", "print-quality=5",
        "-d", printer_name,
        file.path
      ]
  
      output = `#{cmd.shelljoin}`
      success = $?.success?
  
      Rails.logger.info "[LABEL PRINT] Command: #{cmd.shelljoin}"
      Rails.logger.info "[LABEL PRINT] Output: #{output}"
      Rails.logger.info "[LABEL PRINT] Success?: #{success}"
  
      unless success
        raise "Label print failed: #{output}"
      end
    end
  end
end

