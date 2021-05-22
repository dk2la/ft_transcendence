class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :foo

    def foo
        redirect_to profiles_path, notice: "AHahahahahhh, try more take errors suchka"
    end
end
