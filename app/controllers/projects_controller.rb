class ProjectsController < ApplicationController
  before_filter :signed_in_user
  def autocomplete
		@projects = Project.search(params[:term])
		render json: @projects.map(&:name)
	end
	
  def index
    @title = "All Projects"
    @projects = Project.all
    if params[:start_date]
    	@start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
  		@end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
  	else
  		@start_date = Date.today.beginning_of_week(start_day = :sunday)
  		@end_date = Date.today.end_of_week(start_day = :sunday)
  	end
  end
  
  def show
  	@project = Project.find(params[:id])
  	@title = @project.name
  	if params[:start_date]
  		@start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
  		@end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
  	else
  		@start_date = Date.today.beginning_of_week(start_day = :sunday)
  		@end_date = Date.today.end_of_week(start_day = :sunday)
  	end
  end
  
  def edit
  	@project = Project.find(params[:id])
  	@title = "Edit Project"
  	if @project.features.count < 1
  		@project.features.build(featured:false)
  	end
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated."
    	redirect_to projects_path
    else
      @title = "Edit Project"
      render 'edit'
    end
  end

	def destroy
		Project.find(params[:id]).destroy
    flash[:success] = "Project destroyed."
    redirect_to projects_path
  end
  
  def new
  	@project = Project.new
  	@title = "New Project"
  end
  
  def create
    @project = Project.find_or_create_by_name(params[:project][:name])
    @project.save
    current_project=Schedule.find_by_end_at(nil)
    if current_project
    	current_project.update_attributes(end_at:DateTime.now)
    end
    Schedule.create!(project_id:@project.id,start_at:DateTime.now,user_id:current_user.id)
    redirect_to projects_path
  end
  
  
end
