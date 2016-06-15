class GroupsController < AuthenticateController
  before_action :load_group, only: [:show, :edit, :update, :destroy]
  def index
    @groups = current_user.groups.all.order(updated_at: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.users << current_user
      redirect_to edit_group_path(@group), notice: t('messages.created', model: Group.model_name.human)
    else
      render :new
    end
  end

  def show
    @invite = @group.invites.new
    @entries = @group.entries.all.order(created_at: :desc)
  end

  def edit
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

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
