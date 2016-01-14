class TasController < ApplicationController

  def index
  	if !current_user or current_user.type == "Ta"
  		if params[:course].blank?
		   @tas = Ta.all.order("created_at DESC")
		 else
		   @course_id = Course.find_by(name: params[:course]).id
		   @tas = Ta.where(course_id: @course_id).order("created_at DESC")
		 end
  	else
  		if current_user.type == "Student"
  			@tas = Ta.where(course_id: current_user.course_id)
  		end
  	end
  end

  def show
     @ta = Ta.friendly.find(params[:id])
  end

end