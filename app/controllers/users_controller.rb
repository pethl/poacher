class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/:id/edit
  def edit
    authorize! :manage, @user
    @groups = Group.order(:display_name)
  end

  # PATCH /users/:id
  def update
    authorize! :manage, @user

    group_ids = Array(params[:user][:group_ids]).reject(&:blank?)
    @user.groups = Group.where(id: group_ids)
    @user.update!(user_params)

    redirect_to users_path, notice: "Updated #{@user.full_name}."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:dept)
  end
end
