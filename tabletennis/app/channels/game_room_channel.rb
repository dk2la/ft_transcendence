class GameRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_10"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
