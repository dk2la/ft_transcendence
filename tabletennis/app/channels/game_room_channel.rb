class GameRoomChannel < ApplicationCable::Channel
  def subscribed
    p params
    p "SALAMALEIKUM"
    stream_for Game.find(params[:game_room])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
