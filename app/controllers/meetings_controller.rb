class MeetingsController < ApplicationController

  before_action :find_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @ta = Ta.find(params[:ta_id])
  	@meetings= Ta.find(@ta).meetings
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
    #only current user who is TA to create new meeting
    if current_user.type == "Ta"
      @ta = current_user
      @meeting = current_user.meetings.new(meeting_params)
    	if @meeting.save
        flash[:notice] = "Successfully created a meeting."
    		redirect_to meeting_path(@meeting)
    	else
        flash[:errors] = @post.errors.full_messages.join(", ")
    		render action: :new # prevent clearing filled in form when validation failed
    	end
    else
      redirect_to login_path
    end
  end

  def show
  end

  def edit
    #only current logged in ta can see edit view of his non reserved meeting
    @ta = current_user
    unless current_user && current_user.id == @meeting.ta_id && @meeting.student_id == nil
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
        flash[:errors] = @post.errors.full_messages.join(", ")
        # if error redirect back to visited ta meeting list
        redirect_to ta_meetings_path(current_user)
      end
    elsif current_user.type == "Student" && @meeting.student_id == nil
      # when student reserve meeting, add student_id to meeting
      get_student_id = current_user.id
      if @meeting.update_attributes(student_id: get_student_id)
        flash[:notice] = "Successfully reserve a meeting."
        redirect_to student_path(current_user)
      else
        flash[:errors] = @post.errors.full_messages.join(", ")
        # if error redirect back to visited ta meeting list
        redirect_to ta_meetings_path(User.find(@meeting.ta_id))
      end
    else
      redirect_to meeting_path(@meeting)
    end
  end

  def destroy
    if current_user.type == "Ta"
      @meeting.destroy
      flash[:notice] = "Successfully delete the meeting."
      redirect_to ta_path(current_user)
    elsif current_user.type == "Student"
      @meeting.update_attributes(student_id: nil)
      flash[:notice] = "Successfully cancel the meeting."
      redirect_to student_path(current_user)
    else
      redirect_to student_path(current_user)
    end
  end

private
  def meeting_params
    puts params[:start]
    params.require(:meeting).permit(:subject, :start, :end, :ta_id, :student_id)
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

end
