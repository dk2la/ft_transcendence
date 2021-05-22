class ProfilesController < ApplicationController
    before_action :authenticate_user!

    # /GET /home
    def index
      @friends = current_user.friends
    end
  
    # GET /home/:id/edit for render form update user
    def edit
    end
  
<<<<<<< HEAD
=======
    def rating_shop
    end

>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    #PATCH/POST for change home/1 information
    def update
      respond_to do |format|
        if current_user.update(user_params)
          format.html { redirect_to profiles_path, notice: "User was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:nickname, :email, :photo)
    end
end
