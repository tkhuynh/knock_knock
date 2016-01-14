require 'rails_helper'

RSpec.describe UsersController, type: :controller do

	describe "#new" do
		context "anyone can see user new view (landing page)" do
			before do
				get :new
			end

			it "should assign @user" do
				expect(assigns(:user)).to be_instance_of(User)
			end
		end
	end

	describe "#create" do
		context "success for ta(instructor)" do
			before do
				@ta_count = Ta.count
				post :create, user: { name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Ta", course_id: 1 }
			end

			it "should add new user (ta) to the database" do
				expect(Ta.count).to eq(@ta_count + 1)
			end

			it "should redirect_to 'ta_path'" do
				expect(response.status).to be(302)
        expect(response.location).to match(/\/tas\/(\w+-*\w+)+/)
			end
		end

		context "success for student" do
			before do
				@student_count = Student.count
				post :create, user: { name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Student", course_id: 1 }
			end

			it "should add new user (student) to the database" do
				expect(Student.count).to eq(@student_count + 1)
			end

			it "should redirect_to 'student_path'" do
				expect(response.status).to be(302)
        expect(response.location).to match(/\/students\/(\w+-*\w+)+/)
			end
		end		

		context "failed valiadations" do
			before do
				# assume failed one validation (forgot course_id)
				post :create, user: { course_id: nil}
			end

			it "should display error message'Course can't be blank'" do
				expect(flash[:error]).to be_present
			end

			it "should redirect to 'signup_path'" do
        expect(response.status).to be(302)
        expect(response).to redirect_to(signup_path)
      end
		end

		context "if logged in as ta (instructor)" do
			before do
				@current_user = Ta.create(name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Ta", course_id: 1)
				session[:user_id] = @current_user.id

				post :create, user: { name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Ta", course_id: 2 }
			end
			it "should redirect to ta_path" do
				expect(response.status).to be(302)
        expect(response).to redirect_to(ta_path(@current_user))
      end
		end

		context "if logged in as student" do
			before do
				@current_user = Student.create(name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Student", course_id: 1)
				session[:user_id] = @current_user.id

				post :create, user: { name: FFaker::Name.name, email: FFaker::Internet.email, password: FFaker::Lorem.words(6).join, type: "Student", course_id: 2 }
			end
			it "should redirect to student_path" do
				expect(response.status).to be(302)
        expect(response).to redirect_to(student_path(@current_user))
      end
		end


	end

end
