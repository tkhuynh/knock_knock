class TasController < ApplicationController

  def index
    # Only allow student to see this view
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
    @groups = Ta.find(@ta).meetings.group_by { |t| Date.commercial(Time.now.year, t.start_time.to_date.cweek) }
    unless current_user.id == @ta.id or current_user.type == "Student"
      if current_user.type == "Ta"
        redirect_to ta_path(current_user)
      end
    end
  end

end