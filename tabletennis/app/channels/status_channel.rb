class StatusChannel < ApplicationCable::Channel
  def subscribed
    current_user.online!
    stream_from "status_channel"
  end

  def unsubscribed
    current_user.offline!
  end
end
