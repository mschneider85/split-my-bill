class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_group_list

  def filter_groups
    search = "%#{params[:group_name]}%"
    @groups = @groups.where("name ilike :search", search: search) if params[:group_name].present?
  end

  private

  def load_group_list
    @groups ||= current_user.groups.order(updated_at: :desc)
  end
end
