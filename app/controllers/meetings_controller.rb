class MeetingsController < ApplicationController

  before_action :find_meeting, only: [:edit, :update, :destroy]

  def new
    #only current user who is TA to see new meeting form
    if current_user.type == "Ta" 
      @meeting = Meeting.new
    elsif current_user.type == "Student"
      flash[:errors] = "Please email instructor if you need to change date and time."
      redirect_to student_path(current_user)
    else
      flash[:errors] = "Login or signup as TA to create a meeting."
      redirect_to login_path
    end
  end
  
  def create
    if current_user.type == "Ta"
      @ta = current_user
      available_time_start =  Time.parse(meeting_params[:start_time]).to_i
      available_time_end = Time.parse(meeting_params[:end_time]).to_i
      # 30 min slot
      slots = ((available_time_end - available_time_start) / 1800).floor
      if slots > 0 and (available_time_end - available_time_start) % 1800 == 0
        (0...slots).each do |i|
          @meeting = current_user.meetings.new(start_time: Time.at(available_time_start + 1800*i), end_time: Time.at(available_time_start + 1800*(i+1)), ta_id: current_user.id)
          if @meeting.save
          else
            flash[:errors] = @meeting.errors.full_messages.join(", ")
            redirect_to new_meeting_path and return
          end
        end
        if slots == 1
          flash[:notice] = slots.to_s + " meeting has been added to your canlender on " + meeting_params[:start_time].to_date.to_s
          redirect_to ta_path(current_user)
        elsif slots > 1
          flash[:notice] = slots.to_s + " meetings has been added to your canlender on " + meeting_params[:start_time].to_date.to_s
          redirect_to ta_path(current_user)
        else 
          redirect_to ta_path(current_user)
        end
      else
        flash[:errors] = "Duration error: must be interval of 30 min."
        redirect_to new_meeting_path
      end
    elsif current_user.type == "Student"
      redirect_to student_path(current_user)
    else
      redirect_to root_path
    end
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
      ta = Ta.find(@meeting.ta_id)
      if @meeting.update_attributes(subject: get_subject, student_id: get_student_id)
        Notifier.reserved(current_user, @meeting, ta).deliver_now
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
      flash[:errors] = "You can't delete other TA meeting."
      redirect_to ta_path(current_user)
    elsif current_user.type == "Student" && current_user.id == @meeting.student_id
      @meeting.update_attributes(student_id: nil, subject: nil)
      ta = Ta.find(@meeting.ta_id)
      Notifier.cancel(current_user, @meeting, ta).deliver_now
      flash[:notice] = "Successfully cancel the meeting."
      redirect_to student_path(current_user)
    elsif current_user.type == "Student" && current_user.id != @meeting.student_id
      flash[:errors] = "You cant' cancel other student's meeting."
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
