class WelcomeController < ApplicationController
  def index
    redirect_to group_path(cookies[:latest_group]) if cookies[:latest_group]
  end
end
