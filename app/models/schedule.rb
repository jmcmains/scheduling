class Schedule < ActiveRecord::Base
  attr_accessible :end_at, :project_id, :start_at, :project_name
  belongs_to :project
  accepts_nested_attributes_for :project
  
  def happens_during?(start_date,end_date)
  	(start_date < start_at && start_at < end_date) || (start_date < end_at && end_at < end_date)
  end
  
  def project_name
  	project.try(:name)
  end
  
  def project_name=(name)
  	Project.find_or_create_by_name(name) if name.present?
  end
end
