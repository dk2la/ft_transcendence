class GameJob < ApplicationJob
	queue_as :default

	def perform(gameid)
		@game = Game.find(gameid) rescue nil
		if @game == nil then return end

		@gamestate = @game.get_gamelogic
		play_game
		if @gamestate.status == "finished"
			@game.toggle_players_ingame_status
			@game.mydestructor
			@game.is_finished = true
			@game.player1.online!
			@game.player2.online!
			@game.save
			GameRoomChannel.broadcast_to(@game, {
			action: "redirect_after_destroy_room",
			title: "#{@game.id}"
			})
		end
	end

	def play_game
		@game.toggle_players_ingame_status
		@gamestate.countdown
		while @gamestate.status == "running"
			@gamestate.game_engine
			sleep(0.05)
		end
	end
end
