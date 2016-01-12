class SessionsController < ApplicationController

  def new
		#prevent current user to see login page again
		@singup_login_page = true
		if current_user
			redirect_to user_path(current_user)
		end
	end

	def create
		@user = User.find_by_email(params[:email])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			if @user.type == "Ta"
				#after login redirect ta to profile page
				redirect_to ta_path(@user.slug)
			else
				#after login redirect student to all TA page
				redirect_to tas_path
			end
		else
			flash[:error] = "Incorrect email or password."
			redirect_to login_path
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "Successfully logged out."
		redirect_to login_path
	end
	
end
