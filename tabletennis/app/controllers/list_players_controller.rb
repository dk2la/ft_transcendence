class ListPlayersController < ApplicationController
  def index
    @list = User.all
  end

  def show
    p params
    @list = User.find(params[:id])
  end
end
