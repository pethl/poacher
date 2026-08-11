class LabelsController < ApplicationController
 # ------------------------------------------------------------------------------------
  # DEV/TEST-ONLY PREVIEW
  # This endpoint renders a bare HTML preview of a single cheese label so you can
  # adjust layout/size in the browser without sending anything to a printer.
  #
  # Security: no login required *only* in development & test. The route does not
  # exist in production (see routes.rb guard).
  #
  # How to use (dev):
  #   1) Start server:   bin/rails s
  #   2) Find an id:     bin/rails c -> Makesheet.first&.id
  #   3) Open:           http://localhost:3000/labels/<ID>/show_pdf
  #      (Replace <ID> with a real Makesheet id)
  #
  # Notes:
  #   • Renders with layout: false so you see only the label content.
  #   • If you change routes, run: bin/spring stop  (so Spring reloads)
  # ----------------------------------------------------------------------------------
skip_before_action :authenticate_user!, only: [:show_pdf],
if: -> { Rails.env.development? || Rails.env.test? }

  # Printing/holding/releasing a cheese label requires :print_labels on Makesheet
  # (Store and H&S have it; Dairy's :manage covers it too). show_pdf is the dev/test-only
  # unauthenticated preview above and deliberately excluded.
  before_action :authorize_print_labels!, except: [:show_pdf]

    def show_pdf
    @makesheet = Makesheet.find(params[:id])  # (id is actually a makesheet id)
    render layout: false
    end


 
  def print_cheese_labels
    start_date = params[:start_date]
    end_date = params[:end_date]
  
    if start_date.blank? || end_date.blank?
      redirect_to print_wizard_locations_path, alert: "Please select both dates." and return
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



  def print_single_cheese_label
    makesheet = Makesheet.find(params[:makesheet_id])
    pdf = CheeseSingleLabelService.new(makesheet).generate

      send_data pdf,
                filename: "cheese_label_#{makesheet.id}.pdf",
                type: "application/pdf",
                disposition: "inline"
  
  end


  def hold_label
      makesheet = Makesheet.find(params[:makesheet_id])
      pdf = HoldLabelService.new(makesheet).generate

      send_data pdf,
                filename: "hold_label_#{makesheet.id}.pdf",
                type: "application/pdf",
                disposition: "inline"
    end

    def hold_update_label
      makesheet = Makesheet.find(params[:makesheet_id])
      pdf = HoldUpdateLabelService.new(makesheet).generate

      send_data pdf,
                filename: "hold_update_label_#{makesheet.id}.pdf",
                type: "application/pdf",
                disposition: "inline"
    end
    

    def release_label
      makesheet = Makesheet.find(params[:makesheet_id])
      pdf = ReleaseLabelService.new(makesheet).generate

      send_data pdf,
                filename: "release_label_#{makesheet.id}.pdf",
                type: "application/pdf",
                disposition: "inline"
    end

  private

  def authorize_print_labels!
    authorize! :print_labels, Makesheet
  end

end

