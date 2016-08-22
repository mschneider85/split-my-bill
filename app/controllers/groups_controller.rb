class GroupsController < AuthenticateController
  before_action :load_group, only: [:show, :get_chart_data, :edit, :update, :destroy, :updated_at]
  before_action :store_group, only: [:show, :edit, :update]
  skip_before_action :load_group_list, only: [:get_chart_data, :updated_at]
  helper_method :current_membership
  authorize_resource

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
    @activities = params[:all_activities] ? @group.related_activities : @group.related_activities.first(5)
    @commentable = @group
    @comment = Comment.new
    @comments = @commentable.comments.order(created_at: :desc) if params[:tab] == 'comments'
  end

  def get_chart_data
    render json: @group.report.successive_expenses_sum
  end

  def edit
    render layout: false
  end

  def update
    @group.assign_attributes(group_params)
    changes = @group.changes
    if @group.changed? && @group.save
      @group.create_activity key: 'group.update', owner: current_user, parameters: changes
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: t('messages.deleted', model: @group.name)
  end

  def updated_at
    render text: @group.updated_at.to_i
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
