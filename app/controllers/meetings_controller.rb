class MeetingsController < ApplicationController

  before_action :find_meeting, only: [:show, :edit, :update, :destroy]

  def index
  	@meetings= Meeting.all
  end

  def new
    #only current user who is TA to see new meeting form
    if current_user.type == "Ta"    
  	 @meeting = Meeting.new
    else
      flash[:error] = "Login or signup as TA to create a meeting."
      redirect_to login_path
    end
  end

  def create
    #only current user who is TA to create new meeting
    if current_user.type == "Ta"
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

  def update
    if current_user.type == "Student" && @meeting.student_id == nil
      if @meeting.update_attributes(meeting_params)
        flash[:notice] = "Successfully reserved a meeting."
        redirect_to user_path(current_user)
      else
        flash[:errors] = @post.errors.full_messages.join(", ")
        redirect_to user_path(User.find(@meeting.ta_id))
      end
    else
      redirect_to redirect_to meeting_path(@meeting)
    end
  end

  def destroy
    if current_user.type == "Ta"
      @meeting.destroy
      flash[:notice] = "Successfully delete the meeting."
      redirect_to user_path(current_user)
    else
      redirect_to user_path(current_user)
    end
  end

private
  def meeting_params
    params.require(:meeting).permit(:subject, :start, :end, :ta_id, :student_id)
  end

  def find_meeting
    @meeting = Meeting.find(params[:id])
  end

end
