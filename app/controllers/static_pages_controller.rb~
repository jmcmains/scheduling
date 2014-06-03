class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  def home
  	@project = Project.new
  	@schedule = @project.schedules.build
  	@schedules= Schedule.where(user_id: current_user.id).sort_by(&:id).reverse.paginate(:page => 1, :per_page => 10)
  	@page=2;
  	if signed_in?
  		render 'home'
  	else
  		redirect_to signin_url
  	end
  end
  
  def more
    page=params[:page];
		@schedules=Schedule.where(user_id: current_user.id).sort_by(&:id).reverse.paginate(:page => page, :per_page => 10)
		@page = page.to_f+1;
	end
	
	def addnew
		current_project=Schedule.where(end_at: nil, user_id: current_user.id).first
	  if current_project
	  	current_project.update_attributes(end_at:DateTime.now)
	  	@current_schedule=current_project
	  else
	  	@current_schedule=nil
	  end
	  @schedule = Schedule.new(start_at: DateTime.now,user_id: current_user.id)
	  @schedule.save!
	  respond_to do |format|
	    format.html {redirect_to root_path}
	    format.js
	  end
	end
	
end
