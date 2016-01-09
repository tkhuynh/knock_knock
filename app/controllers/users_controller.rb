class UsersController < ApplicationController

  before_action :find_user, except: [:index, :new, :create]
  before_action :authorize, except: [:show, :new, :create]

  def index
    @users = User.all
  end

  def new
    #don't let current user see signup page
    @singup_login_page = true
    if current_user
      redirect_to user_path(current_user)
    else
      @user = User.new
    end
  end

  def create
    #don't let current user create new account
    if current_user
      redirect_to user_path(current_user) 
    else 
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Successfully signed up."
        redirect_to user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.join(', ')
        redirect_to signup_path
      end
    end
  end

  def show
    #see private method
  end

  def edit
    #don't let current user see edit form of other user profile
    #see private method
    unless current_user == @user
      redirect_to user_path(current_user)
    end
  end

  def update
    #only current user can update his own account
    if current_user == @user
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated profile."
        redirect_to user_path(@user)
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
    if current_user.type == "Ta"
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "Successfully delete profile."
      redirect_to user_path(current_user)
    #when logged in student delete his account, set cancel reserved account
    elsif current_user.type == "Student"
      current_user.meetings.each do |meeting|
        meeting.student_id = nil
      end
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "Successfully delete profile."
      redirect_to user_path(current_user)
    else
      flash[:error] = "You can't delete someone else's profile." 
      redirect_to user_path(current_user)
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :image, :type, :password, :password_confirmation)
  end

  def find_user
    @user = User.find_by_id(params[:id])
  end

end
