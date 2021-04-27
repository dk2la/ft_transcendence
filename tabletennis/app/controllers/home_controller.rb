class HomeController < ApplicationController

  def index
  end

  # /GET /home/1 like first user
  def show
  end

  # GET /home/:id/edit for render form update user
  def edit
  end

  #PATCH/POST for change home/1 information
  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to current_user, notice: "User was successfully updated." }
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
