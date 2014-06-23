class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  def home
  	if signed_in?
    	@project = Project.new
    	@schedule = @project.schedules.build
    	@schedules= Schedule.where(user_id: current_user.id).sort_by(&:id).reverse.paginate(:page => 1, :per_page => 10)
    	@page=2;
    	@start_date=Time.zone.now.beginning_of_week
    	@end_date=Time.zone.now.end_of_week
  		render 'home'
  	else
  		redirect_to signin_url
  	end
  end
	
end
