class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
<<<<<<< HEAD
    stream_from "chat_room_channel_#{params[:chat_room_id]}"
=======
    stream_for current_user
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
