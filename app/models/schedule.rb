class Schedule < ActiveRecord::Base

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
  	self.project = Project.where(name: name).first_or_create if name.present?
  end
  
  def self.total_time(span,user)
  	total_time = 0
  	if span == "day"
		begday = 0.minutes.ago.beginning_of_day
		endday = 0.minutes.ago.end_of_day
		elsif span == "week"
		begday = 0.minutes.ago.beginning_of_week(start_day = :sunday)
		endday = 0.minutes.ago.end_of_week(start_day = :sunday)
		end
		Schedule.all.where("user_id = ? AND ((start_at > ? AND start_at < ?) OR (end_at > ? AND end_at < ?))",1,begday,endday,begday,endday).each do |s|
			start = s.start_at
			finish = s.end_at.blank? ? 0.minutes.ago : s.end_at
			if  begday < finish && finish < endday && begday < start && start < endday
			elsif begday < finish && finish < endday
				start = begday
			elsif begday < start && start < endday
				finish = endday
			else
				start = begday
				finish = begday
			end
			total_time = total_time + (finish - start)
		end
		
		return total_time
  end
  
  
  
  def formatted_start_at
		start_at.strftime('%m/%d/%Y %I:%M %p')
	end
	
	def formatted_start_at=(time_str)
		self.start_at = Time.strptime("#{time_str} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p')
	end
	
	def formatted_end_at
		end_at.strftime('%m/%d/%Y %I:%M %p')
	end
	
	def formatted_end_at=(time_str)
		self.end_at = Time.strptime("#{time_str} #{Time.zone.now.strftime('%Z')}", '%m/%d/%Y %I:%M %p')
	end
	
	def self.active_project(user)
  	if where(end_at: nil,user_id: user.id).first
  		where(end_at: nil,user_id: user.id).first.project
  	end
  end
end
