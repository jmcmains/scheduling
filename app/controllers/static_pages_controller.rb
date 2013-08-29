class StaticPagesController < ApplicationController
  def home
  	@project = Project.new
  	@schedule = @project.schedules.build
  	@schedules= Schedule.find_all_by_user_id(current_user).sort_by(&:id).reverse.paginate(:page => params[:page], :per_page => 20)
  	if signed_in?
  		render 'home'
  	else
  		redirect_to signin_url
  	end
  end
end
