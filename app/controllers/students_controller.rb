class StudentsController < ApplicationController
  def show
    @student =Student.find_by_id(params[:id])
  end

  def update
  	@student =Student.find_by_id(params[:id])
  	student_params = params.require(:student).permit(:name, :email, :type, :password, :password_confirmation)
    #only current user can update his own account
    if current_user == @student
      if @student.update_attributes(student_params)
        flash[:notice] = "Successfully updated profile."
        redirect_to student_path(current_user)
      else
        flash[:error] = @student.errors.full_messages.join(', ')
        redirect_to edit_user_path(@student)
      end
    else 
      #if someone else redirect to current user profile
      redirect_to user_path(current_user)
    end
  end

end
