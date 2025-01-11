class UsersController < ApplicationController
  before_action :authenticate_user!
  
  # GET /users or /users.json
  def index
    @users = User.all
  end

end
