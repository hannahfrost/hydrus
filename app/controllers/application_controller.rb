class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include SulChrome::Controller

  include Blacklight::Controller  
  include Hydra::Controller
  include Hydrus::RoutingHacks

  helper Hydrus::RoutingHacks
  helper_method :is_production?
  
  def layout_name
   'sul_chrome/application'
  end
  
  # used to determine if we should show beta message in UI
  def is_production?
    return true if Rails.env.production? and (!request.env["HTTP_HOST"].nil? and !request.env["HTTP_HOST"].include?("-test") and !request.env["HTTP_HOST"].include?("-dev") and !request.env["HTTP_HOST"].include?("localhost"))
  end

  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  protect_from_forgery
end
