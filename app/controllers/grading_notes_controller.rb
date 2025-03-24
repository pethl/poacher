class GradingNotesController < ApplicationController
  before_action :set_grading_note, only: %i[ show edit update destroy ]
  before_action :set_makesheets, only: %i[ new edit update create ]

  # GET /grading_notes or /grading_notes.json
  def index
    @grading_notes = GradingNote.all
  end

  # GET /grading_notes/1 or /grading_notes/1.json
  def show
  end

  # GET /grading_notes/new
  def new
    @grading_note = GradingNote.new

  end

  # GET /grading_notes/1/edit
  def edit
  end

  # POST /grading_notes or /grading_notes.json
  def create
    @grading_note = GradingNote.new(grading_note_params)

    respond_to do |format|
      if @grading_note.save
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
    respond_to do |format|
      if @grading_note.update(grading_note_params)
        format.html { redirect_to @grading_note, notice: "Grading note was successfully updated." }
        format.json { render :show, status: :ok, location: @grading_note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grading_note.errors, status: :unprocessable_entity }
      end
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
