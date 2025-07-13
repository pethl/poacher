class LabelsController < ApplicationController

  def print
    ids = Array(params[:makesheet_id] || params[:ids]) # handle single or multiple
    makesheets = Makesheet.where(id: ids)

    if makesheets.count == 1 && params[:mode] != "batch"
      # Individual compact label (e.g., sticker)
      pdf = CheeseSingleLabelService.new(makesheets.first).generate
    else
      # A4 layout, multiple labels
      pdf = CheeseLabelPdfService.new(makesheets).generate
    end

    send_data pdf,
              filename: "cheese_labels.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  def print_cheese_labels
    start_date = params[:start_date]
    end_date = params[:end_date]
  
    if start_date.blank? || end_date.blank?
      redirect_to labels_path, alert: "Please select both dates." and return
    end
  
    makesheets = Makesheet.where(make_date: start_date..end_date)
    pdf = CheeseMultiLabelService.new(makesheets).generate
  
    send_data pdf, filename: "cheese_labels_#{start_date}_to_#{end_date}.pdf", type: "application/pdf", disposition: "inline"
  end
end

