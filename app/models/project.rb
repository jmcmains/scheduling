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
  
  def time_spent
  	sql = ActiveRecord::Base.connection()
  	d=sql.execute("SELECT sum(strftime('%s', schedules.end_at)- strftime('%s', schedules.start_at)) FROM schedules WHERE schedules.project_id = #{id}")
  	d[0][0]
  end
end
