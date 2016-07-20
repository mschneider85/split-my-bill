class WelcomeController < ApplicationController
  def index
    if current_user
      if current_user.groups.ids.include?(cookies[:latest_group].to_i)
        redirect_to group_path(cookies[:latest_group])
      else
        redirect_to groups_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end
