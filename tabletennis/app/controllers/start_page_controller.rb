class StartPageController < ApplicationController
  def index
    redirect_to home_path if (user_signed_in? != false)
  end
end
