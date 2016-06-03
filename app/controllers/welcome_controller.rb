class WelcomeController < ApplicationController
  #before_action :authenticate_user!
  add_breadcrumb User.human_attribute_name(:email), :root_path
  def index
  end
end
