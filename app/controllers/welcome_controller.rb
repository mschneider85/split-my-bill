class WelcomeController < ApplicationController
  add_breadcrumb User.human_attribute_name(:email), :root_path
  
  def index
  end
end
