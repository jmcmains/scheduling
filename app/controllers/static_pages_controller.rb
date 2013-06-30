class StaticPagesController < ApplicationController
  def home
  	@project = Project.new
  	@schedule = @project.schedules.build
  	if signed_in?
  		render 'home'
  	else
  		redirect_to signin_url
  	end
  end
end
