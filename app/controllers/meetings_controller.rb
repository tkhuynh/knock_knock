class MeetingsController < ApplicationController

  before_action :find_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @ta = Ta.friendly.find(params[:ta_id])
  	@meetings= Ta.find(@ta).meetings.order("start_time ASC")
    @groups = Ta.find(@ta).meetings.group_by { |t| Date.commercial(Time.now.year, t.start_time.to_date.cweek) }
  end

  def new
    #only current user who is TA to see new meeting form
    if current_user.type == "Ta" 
    @ta = current_user   
  	 @meeting = Meeting.new
    else
      flash[:error] = "Login or signup as TA to create a meeting."
      redirect_to login_path
    end
  end
  
  def create
    if current_user.type = "Ta"
      @ta = current_user
      available_time_start =  Time.parse(meeting_params[:start_time]).to_i
      available_time_end = Time.parse(meeting_params[:end_time]).to_i
      # 30 min slot
      slots = ((available_time_end - available_time_start) / 1800).floor
      (0...slots).each do |i|
        @meeting = current_user.meetings.new(start_time: Time.at(available_time_start + 1800*i), end_time: Time.at(available_time_start + 1800*(i+1)), ta_id: current_user.id)
        if @meeting.save
        else
          flash[:errors] = @meeting.errors.full_messages.join(", ")
          render action: :new and return
        end
      end
      redirect_to ta_path(current_user)
    else
      redirect_to login_path
    end
  end

  def show
  end

  def edit
    #only user can see edit or reserve form
    @ta = Ta.find(@meeting.ta_id)
    unless current_user and @meeting.student_id == nil
      redirect_to meeting_path(@meeting)
    end
  end

  def update
    if !current_user
      flash[:errors] = "Please login to reserve or edit."
      redirect_to meeting_path(@meeting)
    elsif current_user.type == "Ta" && @meeting.student_id == nil
      if @meeting.update_attributes(meeting_params)
        flash[:notice] = "Successfully edit a meeting."
        redirect_to ta_path(current_user)
      else
        flash[:errors] = @meeting.errors.full_messages.join(", ")
        # if error redirect back to visited ta meeting list
        redirect_to edit_meeting_path(@meeting)
      end
    elsif current_user.type == "Student" && @meeting.student_id == nil
      # when student reserve meeting, add student_id to meeting
      get_subject = meeting_params[:subject]
      get_student_id = current_user.id
      if @meeting.update_attributes(subject: get_subject, student_id: get_student_id)
        flash[:notice] = "Successfully reserve a meeting."
        redirect_to student_path(current_user)
      else
        flash[:errors] = @meeting.errors.full_messages.join(", ")
        # if error redirect back to visited ta meeting list
        redirect_to edit_meeting_path(@meeting)
      end
    else
      redirect_to meeting_path(@meeting)
    end
  end

  def destroy

    if current_user.type == "Ta" && current_user.id == @meeting.ta_id
      @meeting.destroy
      flash[:notice] = "Successfully delete the meeting."
      redirect_to ta_path(current_user)
    elsif current_user.type == "Ta" && current_user.id != @meeting.ta_id
      flash[:error] = "You can't delete other TA meeting."
      redirect_to ta_path(current_user)
    elsif current_user.type == "Student" && current_user.id == @meeting.student_id
      @meeting.update_attributes(student_id: nil, subject: nil)
      flash[:notice] = "Successfully cancel the meeting."
      redirect_to student_path(current_user)
    elsif current_user.type == "Student" && current_user.id != @meeting.student_id
      flash[:error] = "You cant' cancel other student's meeting."
      redirect_to student_path(current_user)
    elsif !current_user
      redirect_to login_path
    end
  end

private
  def meeting_params
    params.require(:meeting).permit(:subject, :start_time, :end_time, :ta_id, :student_id)
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

end
