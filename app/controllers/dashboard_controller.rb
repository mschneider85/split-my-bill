class DashboardController < AuthenticateController
  authorize_resource class: UserReport

  def index
    @user_report = UserReport.new(current_user)
    respond_to do |format|
      format.html
      format.json { render json: @user_report.chart_data }
    end
  end
end
