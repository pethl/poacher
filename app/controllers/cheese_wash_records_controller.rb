# app/controllers/cheese_wash_records_controller.rb
class CheeseWashRecordsController < ApplicationController
  # Store: manage (they own it) · Cutting: read.
  before_action :authorize_cheese_wash_record_read!, only: %i[index show]
  before_action :authorize_cheese_wash_record_manage!, only: %i[new create edit update]

  def index
    @cheese_wash_records = case params[:status]
    when 'started'
      CheeseWashRecord.where(date_batch_finished: nil)
    when 'finished'
      CheeseWashRecord.where.not(date_batch_finished: nil)
    else
      CheeseWashRecord.all
    end
  end

  def new
    @cheese_wash_record = CheeseWashRecord.new(date_batch_started: Date.today)
    @makesheets = Makesheet.not_finished.ordered
  end

  def create
    @cheese_wash_record = CheeseWashRecord.new(cheese_wash_record_params)
    if @cheese_wash_record.save
      redirect_to cheese_wash_records_path(status: 'started'), notice: "Cheese wash record saved."
    else
      @makesheets = Makesheet.all
      render :new
    end
  end

  def edit
    @cheese_wash_record = CheeseWashRecord.find(params[:id])
    @makesheet = Makesheet.find(@cheese_wash_record.makesheet_id)
  end

  def update
    @cheese_wash_record = CheeseWashRecord.find(params[:id])
    @makesheet = Makesheet.find(@cheese_wash_record.makesheet_id) 

    if @cheese_wash_record.update(cheese_wash_record_params)
      redirect_to cheese_wash_records_path(status: 'started'), notice: "Cheese Wash Record updated successfully."
    else
      @makesheets = Makesheet.all
      render :edit
    end
  end

  def show
    @cheese_wash_record = CheeseWashRecord.find(params[:id])
  end
  
  

  private

  def authorize_cheese_wash_record_read!
    authorize! :read, CheeseWashRecord
  end

  def authorize_cheese_wash_record_manage!
    authorize! :manage, CheeseWashRecord
  end

  def cheese_wash_record_params
    params.require(:cheese_wash_record).permit(
      :makesheet_id,
      :date_batch_started,
      :date_batch_finished,
      *(1..24).map { |i| ["wash_date_#{i}", "number_washed_#{i}"] }.flatten
    )
  end
end
