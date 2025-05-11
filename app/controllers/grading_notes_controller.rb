class GradingNotesController < ApplicationController
  before_action :set_grading_note, only: %i[ show edit update destroy ]
  before_action :set_makesheets, only: %i[ new edit update create ]

  def preload_form
    @staffs = Staff.all_active.ordered
  end 
  
  def preload
    @grading_note = GradingNote.new
  
    # Find the oldest ungraded makesheet
    @starting_makesheet = Makesheet.where(grade: [nil, ""]).order(:make_date).first
  
    # Default the start date to that makesheet’s make_date, or today if none found
    @start_date = @starting_makesheet&.make_date || Date.today
  
    @staffs = Staff.all_active.ordered
  end
  
  def create_preloaded
    start_date = params[:start_date].to_date
    head_taster_id = params[:head_taster]
    assistant_taster_1_id = params[:assistant_taster_1]
    assistant_taster_2_id = params[:assistant_taster_2]
    batch_count = (params[:batch_count].presence || 5).to_i
  
    # ✅ SAFETY CHECK: Require at least head taster + one assistant
    if head_taster_id.blank? || assistant_taster_1_id.blank?
      flash[:alert] = "Please select both a Head Taster and at least one Assistant Taster before continuing."
      redirect_to preload_grading_notes_path(start_date: start_date, batch_count: batch_count,
                                             head_taster: head_taster_id,
                                             assistant_taster_1: assistant_taster_1_id,
                                             assistant_taster_2: assistant_taster_2_id) and return
    end
  
    # ✅ SELECT makesheets with no grade AND no existing grading note
    makesheets_to_grade = Makesheet
      .where(grade: [nil, ""])
      .where("make_date >= ?", start_date)
      .where.not(id: GradingNote.select(:makesheet_id))
      .order(:make_date)
      .limit(batch_count)
  
    if makesheets_to_grade.empty?
      redirect_to grading_notes_path, alert: "No ungraded batches available to preload."
      return
    end
  
    makesheets_to_grade.each do |makesheet|
      GradingNote.create!(
        date: Date.today,
        makesheet_id: makesheet.id,
        head_taster: head_taster_id,
        assistant_taster_1: assistant_taster_1_id,
        assistant_taster_2: assistant_taster_2_id
      )
    end
  
    flash[:alert] = "Only #{makesheets_to_grade.count} grading notes created (less than requested)." if makesheets_to_grade.count < batch_count
  
    redirect_to grading_notes_path, notice: "Preloaded #{makesheets_to_grade.count} grading notes."
  end
  
  

  # GET /grading_notes or /grading_notes.json
  def index
    @grading_notes = GradingNote.all.ordered_by_makesheet_date 
    staff_ids = @grading_notes.flat_map { |g| [g.head_taster, g.assistant_taster_1, g.assistant_taster_2] }.compact.uniq
    @staff_lookup = Staff.where(id: staff_ids).index_by(&:id)
  end

  # GET /grading_notes/1 or /grading_notes/1.json
  def show
  end

  # GET /grading_notes/new
  def new
    @grading_note = GradingNote.new(date: Date.today)
    # Only makesheets that don't have a grade yet
    @makesheets = Makesheet.where(grade: [nil, ""]).order(make_date: :asc)
end

  # GET /grading_notes/1/edit
  def edit
    @grading_note = GradingNote.find(params[:id])
    @makesheets = Makesheet.all
    @staffs = Staff.all

    # Progress tracking
    preloaded_ids = GradingNote.where(date: Date.today).order(:id).pluck(:id)
    @current_batch_number = preloaded_ids.index(@grading_note.id)&.+(1) || 1
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
    @grading_note = GradingNote.find(params[:id])
  
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

    # Only allow a list of trusted parameters through.
    def grading_note_params
      params.require(:grading_note).permit(:makesheet_id, :date, :appearance, :bore, :texture, :taste, :score, :comments, :head_taster, :assistant_taster_1, :assistant_taster_2, makesheet_attributes: [:grade])
    end

    def set_makesheets
      @makesheets = Makesheet.where.not(status: "Finished").ordered_reverse
    end
end
