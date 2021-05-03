class ListPlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show]

  def index
    @list = User.all
  end

  def show
    p params
    @friends = @list.friends
  end

  private

  def find_user
    @list = User.find(params[:id])
  end
end
