class SchedulesController < ApplicationController
  before_filter :signed_in_user
  require 'will_paginate/array'
	
	def calendar_update
		day_delta = params[:day_delta].to_f
		minute_delta = params[:minute_delta].to_f
		@schedule = Schedule.find(params[:id])
		old_start_at = @schedule.start_at
		old_end_at = @schedule.end_at
		if params[:method] == "drop"
			new_start_at = old_start_at + day_delta.day + minute_delta.minute
		else
			new_start_at = old_start_at
		end
		new_end_at = old_end_at + day_delta.day + minute_delta.minute
		@schedule.update_attributes(start_at: new_start_at, end_at: new_end_at)

	end
	
	def new
	  @start_date=Time.zone.today.beginning_of_week
    @end_date=Time.zone.today.end_of_week
    if params[:go] || params[:go_single]
    	@project = Project.where(name: params[:name]).first_or_create
		  @project.save!
    	@command="go"
		 	current_project=Schedule.where(end_at: nil, user_id: current_user.id).first
		  if params[:now] == "true" || params[:go_single]
		  	if current_project
					current_project.update_attributes(end_at:Time.zone.now)
					@current_project=current_project.project
				else
				  @current_project=nil
				end
		  	Schedule.create!(project_id:@project.id,start_at:Time.zone.now,user_id:current_user.id)		  	
		  else
 		  	if current_project
					current_project.update_attributes(end_at:Time.strptime("#{params[:start_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z'))
					@current_project=current_project.project
				else
				  @current_project=nil
				end
		  	Schedule.create!(project_id:@project.id,start_at:Time.strptime("#{params[:start_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z'),user_id:current_user.id)
		 	end
		  featured=@project.features.where(user_id: current_user.id).first
		  if featured.blank?
		    featured=@project.features.where(user_id: current_user.id).first_or_create
        featured.update_attributes(featured:true)
         @new = true
		  elsif featured.featured
		    @new = false
		  else
		    featured=@project.features.where(user_id: current_user.id).first_or_create
        featured.update_attributes(featured:true)
		    @new = true
		  end
		  featured.save!
		elsif params[:del]
		  @project = Project.where(name: params[:name]).first
			@command="del"
			@new = false
			featured=@project.features.where(user_id: current_user.id).first_or_create
			featured.update_attributes(featured:false)
		else
			@command="stop"
			@new = false
			current_project=Schedule.where(end_at: nil, user_id: current_user.id).first
			if current_project
				current_project.update_attributes(end_at:Time.zone.now)
				@current_project=current_project.project
			end
		end

		respond_to do |format|
      format.html {redirect_to request.referer}
      format.js
    end
	end
	
	def index
		@title = "Edit Schedule"
		@per_page = params[:per_page].blank? ? 1 : params[:per_page]
		@schedules = Schedule.where(user_id: current_user.id).sort_by(&:id).reverse.paginate(:page => params[:page], :per_page => @per_page)
		respond_to do |format|
      format.html
      format.js
    end
	end
	
	def edit
		@schedule=Schedule.find(params[:id])
		@schedule.update_attributes(project_name: params[:project_name], start_at: Time.strptime("#{params[:start_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z'), end_at: (!params[:end_at].blank? ? Time.strptime("#{params[:end_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z') : nil))
		respond_to do |format|
      format.html {redirect_to request.referer}
    end
	end

	def pop_up
		@schedule=Schedule.find(params[:id])
	end
		
	def rewrite
		@schedule = Schedule.where(id: params[:id]).first
		@command = params[:commit]
		if @command == "go"
			@schedule.update_attributes(project_name: params[:project_name], start_at: Time.strptime("#{params[:start_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z'), end_at: (!params[:end_at].blank? ? Time.strptime("#{params[:end_at]} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p %Z') : nil))
			featured=@schedule.project.features.where(user_id: current_user.id).first_or_create
			featured.update_attributes(featured: true)
			@schedule.save!
		elsif @command == "del"
		  @schedule.destroy
		end
		respond_to do |format|
	    format.html {redirect_to schedules_path}
	    format.js
	  end
	end
	
	def addnew
		current_project=Schedule.where(end_at: nil, user_id: current_user.id).first
	  if current_project
	  	current_project.update_attributes(end_at:Time.zone.now)
	  	@current_schedule=current_project
	  else
	  	@current_schedule=nil
	  end
	  @schedule = Schedule.new(start_at:Time.zone.now,user_id:current_user.id)
	  @schedule.save!
	  respond_to do |format|
	    format.html {redirect_to schedules_path}
	    format.js
	  end
	end
	
	def destroy
    @schedule=Schedule.where(id: params[:id]).first
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
