module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end
	
	def signed_in?
		!current_user.nil?
	end
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end
	
	def current_user?(user)
		user == current_user
	end
	
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	
	def store_location
		session[:return_to] = request.url
	end
	
	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in." 
		end
	end
	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end
  
  def resource_class
    resource.class
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def after_password_path_for(resource)
  	request.referer
  end
  
  def after_sign_in_path_for(resource)
  	root_path
  end


end
