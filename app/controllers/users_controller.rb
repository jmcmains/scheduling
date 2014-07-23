class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:index, :destroy]
  def show
  	@user = User.find(params[:id])
  	@projects = Project.all
    if params[:start_date]
    	@start_date = Date.strptime(params[:start_date], '%m/%d/%Y').in_time_zone(Time.zone)
  		@end_date = Date.strptime(params[:end_date], '%m/%d/%Y').in_time_zone(Time.zone)
  	else
  		@start_date = Time.zone.now.beginning_of_week(start_day = :sunday)
  		@end_date = Time.zone.now.end_of_week(start_day = :sunday)
  	end
  end
     
  def new
  	@user = User.new
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def create
  	@user = User.new(user_params)
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
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile Updated"
  		sign_in @user
  		redirect_to request.referer
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

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :time_zone)
    end

end
