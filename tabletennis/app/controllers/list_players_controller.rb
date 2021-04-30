class ListPlayersController < ApplicationController
  before_action :authenticate_user!

  def index
    @list = User.all
  end

  def show
    p params
    @list = User.find(params[:id])
  end
end
