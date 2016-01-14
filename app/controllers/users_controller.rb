class UsersController < ApplicationController

  before_action :find_user, except: [:index, :new, :create]
  before_action :authorize, except: [:show, :new, :create]

  def new
    @role = ["Instructor", "Student"]
    @user = User.new
  end

  def create
    #don't let current user create new account
    if !current_user 
      updated_user_params = user_params
      if updated_user_params["type"] == "Instructor"
        updated_user_params["type"] = "Ta"
      end
      @user = User.new(updated_user_params)
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Successfully signed up."
        if @user.type == "Ta"
          redirect_to ta_path(@user)
        else
          redirect_to student_path(@user)
        end
      else
        flash[:error] = @user.errors.full_messages.join(', ')
        redirect_to signup_path
      end
    elsif current_user and current_user.type == "Ta"
      redirect_to ta_path(current_user)
    elsif current_user and current_user.type == "Student"
      redirect_to student_path(current_user)
    end
  end

  def edit
    #don't let current user see edit form of other user profile
    #see private method
    unless current_user == @user
      if current_user.type == "Ta"
        flash[:notice] = "You can only edit your profile."
        redirect_to ta_path(current_user)
      else 
        flash[:notice] = "You can only edit your profile."
        redirect_to student_path(current_user)
      end
    end
  end

  def update
    #only current user can update his own account
    if current_user == @user
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated profile."
        if current_user.type == "Student"
          redirect_to student_path(@user)
        elsif current_user.type == "Ta"
          redirect_to ta_path(@user)
        end
      else
        flash[:error] = @user.errors.full_messages.join(', ')
        redirect_to edit_user_path(@user)
      end
    else 
      #if someone else redirect to current user profile
      redirect_to user_path(current_user)
    end
  end

  def destroy
    #when logged in TA delete 
    if current_user.type == "Ta" && current_user == @user
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "Successfully delete profile."
      redirect_to root_path
    #when logged in student delete his account, set cancel reserved account
    elsif current_user.type == "Student" && current_user == @user
      current_user.meetings.each do |meeting|
        meeting.update_attributes(student_id: nil, subject: nil)
      end
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "Successfully delete profile."
      redirect_to root_path
    else
      flash[:error] = "You can't delete someone else's profile." 
      redirect_to user_path(current_user)
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :image, :course_id, :type, :password, :password_confirmation, :slug)
  end

  def find_user
    @user = User.friendly.find(params[:id])
  end

end
