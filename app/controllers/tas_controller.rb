class TasController < ApplicationController

	before_action :find_ta, only: [:show, :edit, :update, :destroy]

  def index
  	@tas = Ta.all
  end

  def show
  end

  def edit
    #only allow current logged in ta see edit form
    if current_user == @ta

    #prevent ta to see ta edit form
    elsif current_user.type == "Student"
      redirect_to student_path(current_user)
    #prevent current logged in see other ta edit form
    elsif current_user != @ta
      redirect_to ta_path(current_user)
    end
  end

  def update
  	ta_params = params.require(:ta).permit(:name, :email, :type, :password, :password_confirmation)
    #only current user (ta) can update his own account
    if current_user == @ta
      if @ta.update_attributes(ta_params)
        flash[:notice] = "Successfully updated profile."
        redirect_to ta_path(current_user)
      else
        flash[:error] = @ta.errors.full_messages.join(', ')
        redirect_to edit_ta_path(@ta)
      end
    else 
      #if someone else redirect to current user profile
      redirect_to ta_path(current_user)
    end
  end

private
  def find_ta
    @ta = Ta.find_by_id(params[:id])
  end

end
