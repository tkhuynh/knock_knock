class TasController < ApplicationController

  def index
    if !current_user
      redirect_to root_path
  	elsif current_user.type == "Student"
  		@tas = Ta.where(course_id: current_user.course_id)
    elsif current_user.type == "Ta"
      redirect_to ta_path(current_user)
  	end
  end

  def show
     @ta = Ta.friendly.find(params[:id])
  end

end