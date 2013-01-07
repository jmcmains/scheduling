class Schedule < ActiveRecord::Base
  attr_accessible :end_at, :project_id, :start_at
  belongs_to :project
  accepts_nested_attributes_for :project
end
