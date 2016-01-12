class TasController < ApplicationController

  def index
  	@tas = Ta.all
  end

  def show
     @ta = Ta.friendly.find(params[:id])
  end

end
