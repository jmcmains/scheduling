class FeaturesController < ApplicationController

def toggle
	  feature = Feature.find(params[:id])
	  feature.toggle!(:featured)
    respond_to do |format|
      format.html {redirect_to request.referer}
    end
  end
  
end
