class ProjectsController < ApplicationController
  
  def autocomplete
		@projects = Project.search(params[:term])
		render json: @projects.map(&:name)
	end
	
  def index
    @title = "All Projects"
    @projects = Project.all
    if params[:start_date]
  		@start_date = Date.new(params[:start_date][:year].to_i,params[:start_date][:month].to_i,params[:start_date][:day].to_i)
  		@end_date = Date.new(params[:end_date][:year].to_i,params[:end_date][:month].to_i,params[:end_date][:day].to_i)
  	else
  		@start_date = Date.today.beginning_of_week
  		@end_date = Date.today.end_of_week
  	end
  end
  
  def show
  	@project = Project.find(params[:id])
  	if params[:start_date]
  		@start_date = Date.new(params[:start_date][:year].to_i,params[:start_date][:month].to_i,params[:start_date][:day].to_i)
  		@end_date = Date.new(params[:end_date][:year].to_i,params[:end_date][:month].to_i,params[:end_date][:day].to_i)
  	else
  		@start_date = Date.today.beginning_of_week
  		@end_date = Date.today.end_of_week
  	end
  end
  
  def edit
  	@project = Project.find(params[:id])
  	@title = "Edit Project"
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
    Schedule.create!(project_id:@project.id,start_at:DateTime.now)
    redirect_to projects_path
  end
  
  
end
