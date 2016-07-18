class UsersController < ApplicationController
  def index
    @users = current_user.friends
  end

  def show
    @user = User.find(params[:id])
  end
end
