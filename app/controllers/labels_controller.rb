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

  def print_single_cheese
    makesheet = Makesheet.find(params[:makesheet_id])
    CheeseSingleLabelService.new(makesheet).print
  
    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html do
        redirect_back fallback_location: makesheets_path(search: params[:search], month: params[:month]),
                      notice: "Label sent to printer _650."
      end
    end
  end

  # def print_single_cheese
  #   makesheet = Makesheet.find(params[:makesheet_id])
  #   pdf_data = CheeseSingleLabelService.new(makesheet).generate
  
  #   # Save to persistent tmp file
  #   timestamp = Time.now.to_i
  #   path = Rails.root.join("tmp", "cheese_label_#{timestamp}.pdf")
  #   File.open(path, "wb") { |f| f.write(pdf_data) }
  
  #   Rails.logger.info "[LABEL DEBUG] Attempting to print to _650: #{path}"
  
  #   system("/usr/bin/lp", "-d", "_650", path.to_s)
  
  #   Rails.logger.debug("[LABEL DEBUG] Saved persistent path: #{path}")
  
  #   respond_to do |format|
  #     format.turbo_stream { head :ok } # if you're using Turbo
  #     format.html do
  #       redirect_back fallback_location: makesheets_path(search: params[:search], month: params[:month]),
  #                     notice: "Label sent to printer _650."
  #     end
  #   end
  # end
  
end

