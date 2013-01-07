class SchedulesController < ApplicationController
	def new
		@project = Project.find_or_create_by_name(params[:name])
    @project.save
    if params[:go]
		  current_project=Schedule.find_by_end_at(nil)
		  if current_project
		  	current_project.update_attributes(end_at:5.hours.ago)
		  end
		  Schedule.create!(project_id:@project.id,start_at:5.hours.ago)
		else
			current_project=Schedule.find_by_end_at(nil)
			if current_project
				current_project.update_attributes(end_at:5.hours.ago)
			end
		end
		redirect_to root_path
	end

end
