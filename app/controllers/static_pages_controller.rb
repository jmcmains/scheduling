class StaticPagesController < ApplicationController
  before_filter :signed_in_user
  require 'will_paginate/array'
  def home
   	@project = Project.new
   	@start_date=Time.zone.now.beginning_of_week
   	@end_date=Time.zone.now.end_of_week
  end
end
