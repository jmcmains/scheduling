class Schedule < ActiveRecord::Base
  attr_accessible :end_at, :project_id, :start_at, :project_name, :user_id
  belongs_to :project
  accepts_nested_attributes_for :project
  belongs_to :user
  accepts_nested_attributes_for :user
  
  def happens_during?(start_date,end_date)
  	(start_date < start_at && start_at < end_date) || (start_date < end_at && end_at < end_date)
  end
  
  def project_name
  	project.try(:name)
  end
  
  def duration
  	(end_at ? end_at : 0.hours.ago)-start_at
  end
  
  def project_name=(name)
  	Project.find_or_create_by_name(name) if name.present?
  end
  
  def formatted_start_at
		start_at.strftime('%m/%d/%Y %I:%M %p')
	end
	
	def formatted_start_at=(time_str)
		self.start_at = DateTime.strptime(time_str, '%m/%d/%Y %I:%M %p')
	end
	
	def formatted_end_at
		end_at.strftime('%m/%d/%Y %I:%M %p')
	end
	
	def formatted_end_at=(time_str)
		self.end_at = DateTime.strptime(time_str, '%m/%d/%Y %I:%M %p')
	end
	
	def self.active_project(user)
  	if find_by_end_at_and_user_id(nil,user.id)
  		find_by_end_at_and_user_id(nil,user.id).project
  	end
  end
end
