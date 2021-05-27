
class GameRoomChannel < ApplicationCable::Channel
  # @@subscribers = Hash.new

  def subscribed
    current_user.ingame!
    game_room = Game.find(params[:game_room])
    stream_for game_room
    # @@subscribers[game_room.id] ||= 0
    # @@subscribers[game_room.id] += 1

    Thread.new do
      Rails.application.executor.wrap do
        @game = Game.find(game_room.id) rescue nil
        if @game
          @game.send_config
        end
      end
    end
  end

  def input(data)
		if @game
			if current_user == @game.player1
				id = 0
			elsif current_user == @game.player2
				id = 1
			else
				return false
			end
			@game.add_input(data["type"], id)
		end
		true
	end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    current_user.online!
    # @@subscribers[params[:game_room].id] -= 1
  end
end