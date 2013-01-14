class SchedulesController < ApplicationController
	def new
		@project = Project.find_or_create_by_name(params[:name])
		@project.save!
    if params[:go]
		  current_project=Schedule.find_by_end_at(nil)
		  @project.update_attributes(featured: true)
		  if current_project
		  	current_project.update_attributes(end_at:5.hours.ago)
		  end
		  Schedule.create!(project_id:@project.id,start_at:5.hours.ago)
		elsif params[:del]
			@project.update_attributes(featured: false)
		else
			current_project=Schedule.find_by_end_at(nil)
			@project.update_attributes(featured: true)
			if current_project
				current_project.update_attributes(end_at:5.hours.ago)
			end
		end
		@project.save!
		redirect_to root_path
	end
	def index
		@schedules = Schedule.all.sort_by(&:id).reverse
	end
	def update
		@schedule = Schedule.find(params[:id])
		@schedule.update_attributes(params[:schedule])
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
