class GroupsController < AuthenticateController
  before_action :load_group, only: [:show, :edit, :update, :destroy]
  before_action :store_group, only: [:show, :edit, :update]
  helper_method :current_membership

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
      @group.create_activity key: 'group.create', owner: current_user
      redirect_to group_path(@group), notice: t('messages.created', model: Group.model_name.human)
    else
      render :new
    end
  end

  def show
    @invite = @group.invites.new
    @activities = (PublicActivity::Activity.all.where(trackable_id: @group.invites.ids, trackable_type: 'Invite') + PublicActivity::Activity.all.where(trackable_id: @group.entries.ids, trackable_type: 'Entry') + @group.activities).sort{|a, b| a.created_at <=> b.created_at }.reverse
    @activities = @activities.first(5) unless params[:all_activities]
  end

  def edit
    render layout: false
  end

  def update
    if @group.update(group_params)
      @group.create_activity key: 'group.update', owner: current_user
    end
  end

  def destroy
  end

  private

  def load_group
    @group = Group.find_by(id: params[:id])
    redirect_to root_path, alert: t('messages.not_found', model: Group.model_name.human(count: 1)) unless @group
  end

  def store_group
    cookies[:latest_group] = @group.id
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end

  def current_membership
    @current_membership ||= current_user.memberships.find_by(group: @group)
  end
end
