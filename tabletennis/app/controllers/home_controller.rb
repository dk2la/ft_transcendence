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
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end
end
