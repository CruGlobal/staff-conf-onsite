class ApplicationController < ActionController::Base
  include Authenticatable

  protect_from_forgery except: :consume_okta, with: :exception 

  before_action :authenticate_user!, except: :consume_okta
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
end
