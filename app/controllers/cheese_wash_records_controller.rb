# app/controllers/cheese_wash_records_controller.rb
class CheeseWashRecordsController < ApplicationController
  def index
    @cheese_wash_records = CheeseWashRecord.ordered
    #@makesheets = Makesheet.all
  end

  def new
    @cheese_wash_record = CheeseWashRecord.new(date_batch_started: Date.today)
    @makesheets = Makesheet.not_finished.ordered
  end

  def create
    @cheese_wash_record = CheeseWashRecord.new(cheese_wash_record_params)
    if @cheese_wash_record.save
      redirect_to cheese_wash_records_path, notice: "Cheese wash record saved."
    else
      @makesheets = Makesheet.all
      render :new
    end
  end

  def edit
    @cheese_wash_record = CheeseWashRecord.find(params[:id])
    @makesheets = Makesheet.all
  end

  def update
    @cheese_wash_record = CheeseWashRecord.find(params[:id])
    if @cheese_wash_record.update(cheese_wash_record_params)
      redirect_to cheese_wash_records_path, notice: "Cheese Wash Record updated successfully."
    else
      @makesheets = Makesheet.all
      render :edit
    end
  end
  

  private

  def cheese_wash_record_params
    params.require(:cheese_wash_record).permit(
      :makesheet_id,
      :date_batch_started,
      :date_batch_finished,
      *(1..24).map { |i| ["wash_date_#{i}", "number_washed_#{i}"] }.flatten
    )
  end
end
