class UsersController < AuthenticateController
  load_and_authorize_resource

  def index
    @users = current_user.friends
  end

  def show
    @user = User.find(params[:id])
  end
end
