class StartPageController < ApplicationController
  def index
    redirect_to edit_profile_path(id: current_user.id) if (user_signed_in? != false)
  end
end
