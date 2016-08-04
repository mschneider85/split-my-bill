class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #check_authorization

  before_action :load_group_list, :set_conversion_rates

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to request.referrer || dashboard_path, alert: exception.message
    else
      redirect_to new_user_session_path, alert: exception.message
    end
  end

  def filter_groups
    search = "%#{params[:group_name]}%"
    @groups = @groups.where("name ilike :search", search: search) if params[:group_name].present?
  end

  private

  def load_group_list
    @groups ||= current_user.groups.order(updated_at: :desc) if current_user
  end

  def set_conversion_rates
    rates = Rails.cache.fetch "money:eu_central_bank_rates", expires_in: 12.hours do
      Money.default_bank.save_rates_to_s
    end
    Money.default_bank.update_rates_from_s rates
  end
end
