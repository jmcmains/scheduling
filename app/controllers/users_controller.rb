class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:index, :destroy]
  def show
  	@user = User.find(params[:id])
  	@projects = Project.all
    if params[:start_date]
    	@start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
  		@end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
  	else
  		@start_date = Date.today.beginning_of_week-1
  		@end_date = Date.today.end_of_week-1
  	end
  end
  
  def new
  	@user = User.new
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def create
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to Time Saver!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User destroyed"
  	redirect_to users_url
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(params[:user])
  		flash[:success] = "Profile Updated"
  		sign_in @user
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end
  
  private
  
	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end
  	
  	def admin_user
  		redirect_to(root_path) unless (current_user && current_user.admin)
  	end
end
