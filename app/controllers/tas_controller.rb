class TasController < ApplicationController
  def index
  	@tas = Ta.all
  end

  def show
    @ta = Ta.find_by_id(params[:id])
  end
end
