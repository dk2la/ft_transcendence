class StartPageController < ApplicationController
  def index
    redirect_to home_index_path if (user_signed_in? != false)
  end
end
