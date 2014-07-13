module SessionsHelper

	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
	
	def store_location
		session[:return_to] = request.url
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
  
  def signed_in?
		!current_user.nil?
	end
	def current_user?(user)
		user == current_user
	end
	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in." 
		end
	end
end
