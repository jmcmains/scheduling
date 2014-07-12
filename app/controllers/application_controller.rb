class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  around_filter :user_time_zone, if: :current_user
  
  def handle_unverified_request
  	sign_out
  	super
  end
  
  
private

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
