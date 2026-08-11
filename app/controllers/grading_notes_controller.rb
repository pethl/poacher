class GradingNotesController < ApplicationController
  before_action :set_grading_note, only: %i[ show edit update destroy ]
  before_action :set_makesheets, only: %i[ new edit update create ]
  before_action :set_users, only: %i[new edit create update preload preload_form]

  # Office: manage · H&S: read · Cutting: read.
  before_action :authorize_grading_note_read!, only: %i[index show]
  before_action :authorize_grading_note_manage!, only: %i[
    new edit create update destroy preload preload_form create_preloaded
  ]

  def preload_form
    @users = User.where(account_active: true).ordered
  end 
  

  def preload
    @grading_note = GradingNote.new

    @starting_makesheet =
      Makesheet
      .where(grade: [nil, ""])
      .order(:make_date)
      .first

    @start_date =
      params[:start_date].presence&.to_date ||
      @starting_makesheet&.make_date ||
      Date.current

   
  end


  def create_preloaded
    start_date = params[:start_date].to_date
    head_taster_id = params[:head_taster_id]
    taster_1_name = params[:taster_1_name]
    taster_2_name = params[:taster_2_name]
    batch_count = (params[:batch_count].presence || 5).to_i

    if head_taster_id.blank?
      redirect_to(
        preload_grading_notes_path(
          start_date: start_date,
          batch_count: batch_count,
          head_taster_id: head_taster_id,
          taster_1_name: taster_1_name,
          taster_2_name: taster_2_name
        ),
        alert: "Please select the Head Taster before continuing."
      )
      return
    end

    makesheets_to_grade =
      Makesheet
      .where(grade: [nil, ""])
      .where("make_date >= ?", start_date)
      .where.not(id: GradingNote.select(:makesheet_id))
      .order(:make_date)
      .limit(batch_count)

    if makesheets_to_grade.empty?
      redirect_to(
        grading_notes_path,
        alert: "No ungraded batches available to preload."
      )
      return
    end

    makesheets_to_grade.each do |makesheet|
      GradingNote.create!(
        date: Date.current,
        makesheet: makesheet,
        head_taster_id: head_taster_id,
        taster_1_name: taster_1_name,
        taster_2_name: taster_2_name
      )
    end

    if makesheets_to_grade.count < batch_count
      flash[:alert] =
        "Only #{makesheets_to_grade.count} grading notes created (less than requested)."
    end

    redirect_to(
      grading_notes_path,
      notice: "Preloaded #{makesheets_to_grade.count} grading notes."
    )
  end

  # GET /grading_notes or /grading_notes.json
  def index
    @grading_notes =
      GradingNote
      .includes(:makesheet, :head_taster)
      .ordered_by_makesheet_date
  end

  # GET /grading_notes/1 or /grading_notes/1.json
  def show
  end

  # GET /grading_notes/new
  def new
    @grading_note = GradingNote.new(
      date: Date.current
    )
  end

  # GET /grading_notes/1/edit
  def edit
   
    preloaded_ids =
      GradingNote
      .where(date: Date.current)
      .order(:id)
      .pluck(:id)

    @current_batch_number =
      preloaded_ids.index(@grading_note.id)&.+(1) || 1

    @total_batches = preloaded_ids.count
  end

  # POST /grading_notes or /grading_notes.json
  def create
    @grading_note = GradingNote.new(grading_note_params)
  
    respond_to do |format|
      if @grading_note.save
        # ✅ Only update makesheet grade if one was selected
        if params[:makesheet_grade].present?
          makesheet = Makesheet.find_by(id: @grading_note.makesheet_id)
          makesheet.update(grade: params[:makesheet_grade]) if makesheet
        end
  
        format.html { redirect_to @grading_note, notice: "Grading note was successfully created." }
        format.json { render :show, status: :created, location: @grading_note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grading_note.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /grading_notes/1 or /grading_notes/1.json
  def update
   
    if @grading_note.update(grading_note_params)
      if params[:commit] == "save_next"
        next_note = GradingNote.where("id > ?", @grading_note.id).order(:id).first
        if next_note
          redirect_to edit_grading_note_path(next_note), notice: "Saved and moving to next note"
        else
          redirect_to grading_notes_path, notice: "Saved. No more grading notes."
        end
      else
        redirect_to grading_note_path(@grading_note), notice: "Grading note updated"
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /grading_notes/1 or /grading_notes/1.json
  def destroy
    @grading_note.destroy!

    respond_to do |format|
      format.html { redirect_to grading_notes_path, status: :see_other, notice: "Grading note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grading_note
      @grading_note = GradingNote.find(params[:id])
    end

    def authorize_grading_note_read!
      authorize! :read, @grading_note || GradingNote
    end

    def authorize_grading_note_manage!
      authorize! :manage, @grading_note || GradingNote
    end

    # Only allow a list of trusted parameters through.
    def grading_note_params
      params.require(:grading_note).permit(:makesheet_id, :date, :appearance, :bore, :texture, :taste, :score, :comments, :head_taster_id, :taster_1_name, :taster_2_name, makesheet_attributes: [:grade])
    end

    def set_makesheets
      @makesheets = Makesheet.where.not(status: "Finished").ordered_reverse
    end

    def set_users
      @users = User.active.ordered
    end
end
