class StudentsController < ApplicationController

  def show
    @student =Student.friendly.find(params[:id])
  end

end
