class WelcomeController < ApplicationController
  def index
    redirect_to group_path(cookies[:latest_group]) if current_user && current_user.groups.ids.include?(cookies[:latest_group].to_i)
  end
end
