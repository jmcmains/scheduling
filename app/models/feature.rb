class Feature < ActiveRecord::Base
  attr_accessible :featured
  belongs_to :project
  accepts_nested_attributes_for :project
  belongs_to :user
  accepts_nested_attributes_for :user
end
