class StudentsController < ApplicationController

  before_action :find_student, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
    #only allow current logged in student see edit form
    if current_user == @student

    #prevent ta to see student edit form
    elsif current_user.type == "Ta"
      redirect_to ta_path(current_user)
    #prevent current logged in see other student edit form
    elsif current_user != @student
      redirect_to student_path(current_user)
    end
  end

  def update
  	student_params = params.require(:student).permit(:name, :email, :type, :password, :password_confirmation)
    #only current user (student) can update his own account
    if current_user == @student
      if @student.update_attributes(student_params)
        flash[:notice] = "Successfully updated profile."
        redirect_to student_path(current_user)
      else
        flash[:error] = @student.errors.full_messages.join(', ')
        redirect_to edit_student_path(@student)
      end
    else 
      #if someone else redirect to current user profile
      redirect_to student_path(current_user)
    end
  end

  def destroy
    if current_user.type == "Student"
      current_user.meetings.each do |meeting|
        meeting..update_attributes(student_id: nil)
      end
      @student.destroy
      session[:user_id] = nil
      flash[:notice] = "Successfully delete profile."
      redirect_to root_path
    else
      redirect_to student_path(current_user) || ta_path(current_user)
    end
  end

private
  def find_student
    @student =Student.find_by_id(params[:id])
  end

end
