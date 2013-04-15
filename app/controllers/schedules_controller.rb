class SchedulesController < ApplicationController
  before_filter :signed_in_user
  require 'will_paginate/array'
	def new
		@project = Project.find_or_create_by_name(params[:name].titlecase)
		@project.save!
    if params[:go]
		  current_project=Schedule.find_by_end_at_and_user_id(nil,current_user.id)
		  if current_project
		  	current_project.update_attributes(end_at:DateTime.now)
		  end
		  Schedule.create!(project_id:@project.id,start_at:DateTime.now,user_id:current_user.id)
		elsif params[:del]
		else
			current_project=Schedule.find_by_end_at_and_user_id(nil,current_user.id)
			if current_project
				current_project.update_attributes(end_at:DateTime.now)
			end
		end
		@project.save!
		featured=@project.features.find_or_create_by_user_id(current_user.id)
		if params[:del]
			featured.update_attributes(featured:false)
		else
			featured.update_attributes(featured:true)
		end
		featured.save!
		respond_to do |format|
      format.html {redirect_to root_path}
      format.js
    end
	end
	def index
		@title = "Edit Schedule"
		@schedules = Schedule.find_all_by_user_id(current_user).sort_by(&:id).reverse.paginate(:page => params[:page], :per_page => 20)
	end
	
	def rewrite
		@schedule = Schedule.find(params[:id])
		@command = params[:commit]
		if @command == "go"
			@schedule.update_attributes(project_id: Project.find_or_create_by_name(params[:project_name]).id, start_at: DateTime.strptime(params[:start_at], '%m/%d/%Y %I:%M %p %Z'), end_at: (!params[:end_at].blank? ? DateTime.strptime(params[:end_at], '%m/%d/%Y %I:%M %p %Z') : nil))
			@schedule.save!
		elsif @command == "del"
		  @schedule.destroy
		end
		respond_to do |format|
	    format.html {redirect_to schedules_path}
	    format.js
	  end
	end
	
	
	def destroy
    @schedule=Schedule.find(params[:id])
    @schedule.destroy
    respond_to do |format|
      format.html {redirect_to schedules_path}
      format.js
    end
  end
  def calendar
  	@title= "Calendar"
  end
  
end
