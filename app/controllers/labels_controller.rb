class LabelsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show_pdf]


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


  def preview_single_cheese
    makesheet = Makesheet.find(params[:makesheet_id])
    pdf = CheeseSingleLabelService.new(makesheet).generate
  
    send_data pdf, filename: "cheese_label_#{makesheet.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  def show_pdf
    @makesheet = Makesheet.find(params[:id])
    render layout: false
  end

  def print_single_cheese_label
    makesheet = Makesheet.find(params[:makesheet_id])
    CheeseSingleLabelService.new(makesheet).print
  
    redirect_back fallback_location: makesheets_path,
                  notice: "Label sent to printer."
  end
  
  
end

