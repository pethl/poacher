class ScaleChecksController < ApplicationController
  before_action :set_scale_check, only: %i[show edit update destroy]
  before_action :set_users, only: %i[new edit create update]

  # Office: read · H&S: read · Cutting: manage (they own it).
  before_action :authorize_scale_check_read!, only: %i[index show week_view]
  before_action :authorize_scale_check_manage!, only: %i[new create edit update destroy]

  def index
    @scale_checks = ScaleCheck.all
  end 

  def week_view
   
    @week_start = Date.today.beginning_of_week(:monday)
    start_date = Date.today.beginning_of_week
    end_date = Date.today.end_of_week
  
    @scale_names = Reference.where(active: true, group: 'scale_name_serial').where(description: 'Daily').order(:id).pluck(:value) 
    @weekly_pan_scale_names = Reference.where(active: true, group: 'scale_name_serial', description: 'Pan').order(:id).pluck(:value)
    @weekly_individual_scale_names = Reference.where(active: true, group: 'scale_name_serial', description: 'Individual').order(:id).pluck(:value)
  
    @scale_checks = ScaleCheck.where(frequency: 'Daily', check_date: start_date..end_date)

    @daily_checks = ScaleCheck.where(frequency: 'Daily', check_date: start_date..end_date)
    @weekly_pan_checks = ScaleCheck.where(frequency: 'Weekly', scale_name: @weekly_pan_scale_names, check_date: start_date..end_date)
    @weekly_individual_checks = ScaleCheck.where(frequency: 'Weekly', scale_name: @weekly_individual_scale_names, check_date: start_date..end_date)

  end

  def show
  end

  def new
    @scale_check = ScaleCheck.new(
      scale_name: params[:scale_name],
      check_date: params[:check_date],
      frequency: params[:frequency],
      user: current_user
    )
  end


  def edit
    # Whoever opens the edit form is doing the signing — default to them.
    @scale_check.user = current_user
  end

  def create
    @scale_check = ScaleCheck.new(scale_check_params)
   
    if @scale_check.save
      redirect_to week_view_scale_checks_path, notice: "Scale check was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @scale_check.update(scale_check_params)
      redirect_to week_view_scale_checks_path, notice: "Scale check was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @scale_check.destroy
    redirect_to scale_checks_url, notice: "Scale check was successfully destroyed."
  end

  private

  def set_scale_check
    @scale_check = ScaleCheck.find(params[:id])
  end

  def authorize_scale_check_read!
    authorize! :read, @scale_check || ScaleCheck
  end

  def authorize_scale_check_manage!
    authorize! :manage, @scale_check || ScaleCheck
  end

  def scale_check_params
    params.require(:scale_check).permit(:frequency, :check_date, :scale_name, 
                                        :scale_100g, :scale_500g, :scale_1kg, 
                                        :scale_5kg, :scale_10kg, :scale_20kg, :comments, 
                                        :signature, :user_id)
  end

  def set_users
      @users = User.where(
        dept: "Cutting Room",
        employment_status: "Active"
      ).ordered
    end
end

