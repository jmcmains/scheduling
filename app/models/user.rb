class User < ActiveRecord::Base


  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :time_zone, 
    inclusion: { 
      in: ActiveSupport::TimeZone.zones_map(&:name).keys 
    } 
  has_many :features, dependent: :destroy
  accepts_nested_attributes_for :features
  
  def working?
  	!Schedule.find_by_end_at_and_user_id(nil,id).blank?
  end

  
  private
  
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
