# frozen_string_literal: true

require 'grover'
require 'tempfile'

class CheeseLabelPrintService
  def initialize(makesheet)
    @makesheet = makesheet
  end

  def print
    label_url = Rails.application.routes.url_helpers.show_pdf_label_url(
      @makesheet,
      host: 'http://localhost:3000'
    )
  
    pdf = Grover.new(
      label_url,
      width: '89mm',
      height: '41mm',
      margin: '0mm',
      print_background: true
    ).to_pdf
  
    # Save first to inspect visually
    path = Rails.root.join("tmp", "debug_label_#{@makesheet.id}.pdf")
    File.open(path, 'wb') { |f| f.write(pdf) }
  
    Rails.logger.info "[LABEL DEBUG] Saved to: #{path}"
  
    # Then print
    system('/usr/bin/lp',
           '-o', 'PageSize=Custom.89x41mm',
           '-o', 'fit-to-page=false',
           '-o', 'scaling=100',
           '-d', '_650',
           path.to_s)
  end
end
