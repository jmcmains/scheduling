class Project < ActiveRecord::Base
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
  		return all
  	end
  end
  
  def in_use?(user)
  	schedules.where(user_id: user.id).sort_by(&:updated_at).last.updated_at > 100.weeks.ago
  end
  
  def project_name	
  	try(:name)
  end
  
  def project_name=(name)
  	Project.find_or_create_by_name(name) if name.present?
  end
  
  def active?(user)
  	!schedules.where(end_at: nil, user_id: user.id).blank?
  end
  
  def self.active(user)
    if !Schedule.where(end_at: nil, user_id: user.id).blank?
      return Schedule.where(end_at: nil, user_id: user.id).first.project
    else
      return nil
    end
  end
  
  
  def time_spent(start_date,end_date,user)
  	total_time = 0
		schedules.where(user_id: user.id).each do |s|
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
		Schedule.where(user_id: user.id).each do |s|
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
