class GroupsController < AuthenticateController
  before_action :load_group, only: [:edit, :update, :destroy]
  def index
    @groups = current_user.groups.all
  end

  def edit
    @invite = @group.invites.new
  end

  def update
  end

  def destroy
  end

  private

  def load_group
    @group = Group.find_by(id: params[:id])
    redirect_to root_path, alert: t('messages.not_found', model: Group.model_name.human(count: 1)) unless @group
  end
end
