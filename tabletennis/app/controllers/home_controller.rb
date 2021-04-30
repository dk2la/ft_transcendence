class HomeController < ApplicationController
  before_action :authenticate_user!
  
  # /GET /home
  def index
    @friends = current_user.friends
  end

  # GET /home/:id/edit for render form update user
  def edit
  end

  def invite_friend
    debugger
    p params
    @cur_user = User.find(params.require(:id))
    p @cur_user.nickname
    @friend = Friendship.create(user_id: current_user.id, friend_id: @cur_user.id)
  end

  #PATCH/POST for change home/1 information
  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to home_index_path, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email)
  end
end
