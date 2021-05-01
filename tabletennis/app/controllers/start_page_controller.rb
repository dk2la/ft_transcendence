class StartPageController < ApplicationController
  def index
    redirect_to profiles_path if (user_signed_in? != false)
  end
end
