class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :features, dependent: :destroy
  accepts_nested_attributes_for :features
  
  def working?
   !Schedule.find_by_end_at_and_user_id(nil,id).blank?
  end

  def self.from_omniauth(auth)
   where(auth.slice(:provider, :uid)).first_or_create do |user|
		 user.provider = auth.provider
		 user.uid = auth.uid
		 user.name = auth.info.nickname
   end
  end
  
  def connect_to_omniauth(auth)
  	update_attributes(provider: auth.provider, uid: auth.uid)
  end
  
  def self.new_with_session(params, session)
   if session["devise.user_attributes"]
new session["devise.user_attributes"] do |user|
user.attributes = params
user.valid?
   end
   else
   super
   end
  end
  
  def password_required?
   super && provider.blank?
  end
  
  def update_with_password(params, *options)
   if encrypted_password.blank?
   update_attributes(params,*options)
   else
   super
   end
  end
  
  def email_required?
   super && provider.blank?
  end
  private
  
   def create_remember_token
   self.remember_token = SecureRandom.urlsafe_base64
   end
end
