class Project < ActiveRecord::Base
  attr_accessible :name, :featured, :features_attributes
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules
  has_many :features, dependent: :destroy
  accepts_nested_attributes_for :features
  def self.search(search)
  	if search
			words = search.to_s.strip.split
		  words.inject(scoped) do |combined_scope, word|
		    combined_scope.where('LOWER(name) LIKE ?',"%#{word.downcase}%")
		  end
  	else
  		return find(:all)
  	end
  end
  
  def in_use?(user)
  	schedules.find_all_by_user_id(user).sort_by {|a| a.updated_at }.last.updated_at > 100.weeks.ago
  end
  
  def project_name	
  	try(:name)
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
		all.each do |project|
			project.schedules.find_all_by_user_id(user.id).each do |s|
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
		end
		return total_time
  end
  
  def project_name=(name)
  	Project.find_or_create_by_name(name) if name.present?
  end
  
  def active?(user)
  	!schedules.find_by_end_at_and_user_id(nil,user.id).blank?
  end
  
  
  def time_spent(start_date,end_date,user)
  	total_time = 0
		schedules.find_all_by_user_id(user.id).each do |s|
			start = s.start_at
			finish = s.end_at.blank? ? 0.minutes.ago : s.end_at
			if (start_date.to_datetime < finish && finish < (end_date.to_datetime+1.day)) && (start_date.to_datetime < start && start < (end_date.to_datetime+1.day))
			elsif (start_date.to_datetime < finish && finish < (end_date.to_datetime+1.day))
				start = start_date.to_datetime
			elsif (start_date.to_datetime < start && start < (end_date.to_datetime+1.day))
				finish = end_date.to_datetime+1.day
			else
				start = start_date
				finish = start_date
			end
			total_time = total_time + (finish - start)
		end
		return total_time
  end
  
  def self.time_spent(start_date,end_date,user)
  	total_time = 0
		Schedule.find_all_by_user_id(user.id).each do |s|
			start = s.start_at
			finish = s.end_at.blank? ? 0.minutes.ago : s.end_at
			if (start_date.to_datetime < finish && finish < (end_date.to_datetime+1.day)) && (start_date.to_datetime < start && start < (end_date.to_datetime+1.day))
			elsif (start_date.to_datetime < finish && finish < (end_date.to_datetime+1.day))
				start = start_date.to_datetime
			elsif (start_date.to_datetime < start && start < (end_date.to_datetime+1.day))
				finish = end_date.to_datetime+1.day
			else
				start = start_date
				finish = start_date
			end
			total_time = total_time + (finish - start)
		end
		return total_time
  end
  
end
