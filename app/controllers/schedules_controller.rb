class SchedulesController < ApplicationController
  require 'will_paginate/array'
	def new
		@project = Project.find_or_create_by_name(params[:name])
		@project.save!
    if params[:go]
		  current_project=Schedule.find_by_end_at(nil)
		  @project.update_attributes(featured: true)
		  if current_project
		  	current_project.update_attributes(end_at:DateTime.now.in_time_zone("Eastern Time (US & Canada)"))
		  end
		  Schedule.create!(project_id:@project.id,start_at:DateTime.now.in_time_zone("Eastern Time (US & Canada)"))
		elsif params[:del]
			@project.update_attributes(featured: false)
		else
			current_project=Schedule.find_by_end_at(nil)
			@project.update_attributes(featured: true)
			if current_project
				current_project.update_attributes(end_at:DateTime.now.in_time_zone("Eastern Time (US & Canada)"))
			end
		end
		@project.save!
		redirect_to root_path
	end
	def index
		@schedules = Schedule.all.sort_by(&:id).reverse.paginate(:page => params[:page], :per_page => 10)
	end
	def update
		@schedule = Schedule.find(params[:id])
		@schedule.update_attributes(params[:schedule])
		@schedule.update_attributes(:project_id => Project.find_or_create_by_name(params[:schedule][:project_name]).id)
		respond_to do |format|
      format.html {redirect_to schedules_path}
      format.js
    end
	end
	def destroy
    Schedule.find(params[:id]).destroy
    redirect_to schedules_path 
  end
  def calendar
  end
end
