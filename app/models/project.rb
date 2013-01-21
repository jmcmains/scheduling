class Project < ActiveRecord::Base
  attr_accessible :name, :featured
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules
  
  
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
  
  def project_name
  	try(:name)
  end
  
  def project_name=(name)
  	Project.find_or_create_by_name(name) if name.present?
  end
  
  def active?
  	!Schedule.find_by_project_id_and_end_at(id,nil).blank?
  end
  
  def time_spent(start_date,end_date)
  	total_time = 0
		schedules.each do |s|
			start = s.start_at
			finish = s.end_at.blank? ? 5.hours.ago : s.end_at
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
