

class Player
	attr_accessor :inputs
	def initialize(id, x, cwidth, cheight, paddle, user, long_paddles)
        @status = "ready"
        @ai = false
        @ai = (user == nil)
        if user
            @name = user.nickname
            @user_id = user.id
            @status = "waiting"
        else
            @name = "BOT"
            @user_id = 0
        end
        @left_right = id
        @score = 0
		@paddle = paddle
		@inputs = Array.new
	end

	def inc_score
		@score += 1
	end

	def move_paddle(action, grid, maxPaddleY)
		return unless action

		if action[:action] == "paddle_up"
			p "THIS IS MAXPADDLEY #{maxPaddleY}"
			@paddle[:dy] = -6
			@paddle[:y] += @paddle[:dy]
			if @paddle[:y] > maxPaddleY
				p "THIS IS MAXPADDLEY AFTER IF for UP #{maxPaddleY}"
				p "THIS IS PADDLE[:Y] AFTER IF for UP #{@paddle[:y]}"
				@paddle[:y] = maxPaddleY
			end
		elsif action[:action] == "paddle_down"
			@paddle[:dy] = 6
			@paddle[:y] += @paddle[:dy]
			if @paddle[:y] < grid
				p "THIS IS GRID AFTER IF for UP #{grid}"
				p "THIS IS PADDLE[:Y] AFTER IF for UP #{@paddle[:y]}"
				@paddle[:y] = grid
			end
		end
	end

	def move(ball, grid, maxPaddleY)
		if @inputs.length > 0
			move_paddle(@inputs.pop, grid, maxPaddleY)
		end
	end

	def change_status
		if @status == "waiting"
			@status = "ready"
		elsif @status == "ready"
			@status = "waiting"
		end
	end

	def add_move(new_move)
		unless @ai
			@inputs.unshift(new_move)
		end
	end

	def reset_paddle_dy
		@paddle[:dy] = 0
	end

	#GETTERS FOR PLAYER VALUES
	def name
		@name
	end

	def score
		@score
	end

	def paddle
		@paddle
	end

	def user_id
		@user_id
	end

	def status
		@status
	end
end

class Gamelogics
	attr_accessor	:ball, :left_paddle, :right_paddle, :cheight,
					:cwidth, :grid, :paddleHeight, :maxPaddleY,
					:paddleSpeed, :ballSpeed, :status, :winner

	def initialize(game)
		@msg = nil
		@turn = 0
		@game = game
		# info about canvas
		@cheight = 585
		@cwidth = 750
		
		# info about game
		@status = "running"
		@winner = "TBD"
		
		# info about ball and paddles
		@grid = 15
		@paddleHeight = @grid * 5
		@maxPaddleY = @cheight - @grid - @paddleHeight
		@paddleSpeed = 6
		@ballSpeed = 5
		
		@ball = {
			x: @cwidth / 2,
			y: @cheight / 2,

			width: @grid,
			height: @grid,

			resseting: false,
			dx: @ballSpeed,
			dy: @ballSpeed * -1
		}

		@left_paddle = {
			x: @grid * 2,
			y: @cheight / 2 - @paddleHeight / 2,
			width: @grid,
			height: @paddleHeight,
			dy: 0
		}

		@right_paddle = {
			x: @cwidth - @grid * 3,
			y: @cheight / 2 - @paddleHeight / 2,
			width: @grid,
			height: @paddleHeight,
			dy: 0
		}
		#info about player
		@players = [
			Player.new(0, 5, @cwidth, @cheight, @left_paddle, game.player1, game.long_paddles),
			Player.new(1, @cwidth - 20, @cwidth, @cheight, @right_paddle, game.player2, game.long_paddles)
		]
	end

	def send_config
		obj = {
			config: {
				status: @status,
				winner: @winner,
				message: @msg,
				canvas: {
					width: @cwidth,
					height: @cheight
				},
				players: [
					{
						name: @players[0].name,
						score: @players[0].score,
						paddle: {
							width: @players[0].paddle[:width],
							height: @players[0].paddle[:height],
							x: @players[0].paddle[:x],
							y: @players[0].paddle[:y],
							dy: @players[0].paddle[:dy]
						}
					},
					{
						name: @players[1].name,
						score: @players[1].score,
						paddle: {
							width: @players[1].paddle[:width],
							height: @players[1].paddle[:height],
							x: @players[1].paddle[:x],
							y: @players[1].paddle[:y],
							dy: @players[1].paddle[:dy]
						}
					}
				],
				ball: {
					x: @ball[:x],
					y: @ball[:y],
		
					width: @ball[:width],
					height: @ball[:height],
		
					resseting: @ball[:resseting],
					dx: @ball[:dx],
					dy: @ball[:dy]
				}
			}
		}
		GameRoomChannel.broadcast_to(@game, obj)
	end

	def validate_action(action, user_id, game_id)
		STDERR.puts "adding action id is #{user_id}, action is #{action}"
		if action == "ready"
			@players[user_id.to_i].change_status
			if @players[0].status == "ready" && @players[1].status == "ready"
				GameJob.perform_later(game_id)
			end
		end
		@players[user_id].add_move({action: action, id: user_id})
	end

	def status # simple getter method
		if @status == "finished"
			"finished"
		elsif @players[0].status == "waiting" or @players[1].status == "waiting"
			"waiting"
		else
			"running"
		end
	end

	def finish_game
		@status = "finished"

		if @players[0].score.to_i >  @players[1].score.to_i
			@winner = @players[0].name
			winner_id = @players[0].user_id
			loser_id = @players[1].user_id
		else
			@winner = @players[0].name
			winner_id = @players[1].user_id
			loser_id = @players[0].user_id
		end
		@msg = "#{@winner}, wins!"
		# need add change rating after game
	end

	def countdown
		@status = "countdown"
		5.downto(0) do |n|
			if n == 0 then @msg = nil else @msg = "Game starting in #{n}" end
			send_config
			sleep(1)
		end
		@status = "running"
		@msg = nil
	end

	def score
	end

	def collides(obj1, obj2)
		# p "this is OBJ1 #{obj1}"
		# p "this is OBJ2 #{obj2}"
		return obj1[:x] < obj2[:x] + obj2[:width] &&
        obj1[:x] + obj1[:width] > obj2[:x] &&
        obj1[:y] < obj2[:y] + obj2[:height] &&
        obj1[:y] + obj1[:height] > obj2[:y];
	end

	def updateballpos

		# Если мяч коснулся левой платформы,
		if collides(@ball, @left_paddle)
		  # то отправляем его в обратном направлении
		  @ball[:dx] *= -1;
		  # Увеличиваем координаты мяча на ширину платформы, чтобы не засчитался новый отскок
		  @ball[:dx] = @left_paddle[:x] + @left_paddle[:width];
		# Проверяем и делаем то же самое для правой платформы
		elsif collides(@ball, @right_paddle)
		  @ball[:dx] *= -1;
		  @ball[:x] = @right_paddle[:x] - @ball[:width];
		end

		@ball[:x] += @ball[:dx];
      	@ball[:y] += @ball[:dy];
      	# Если мяч касается стены снизу — меняем направление по оси У на противоположное
      	if @ball[:y] < @grid
        	@ball[:y] = @grid;
        	@ball[:dy] *= -1;
      	# Делаем то же самое, если мяч касается стены сверху
      	elsif @ball[:y] + @grid > @cheight - @grid
 	       @ball[:y] = @cheight - @grid * 2;
    	    @ball[:dy] *= -1;
		end

		if (@ball[:x] < 0 || @ball[:x] > @cwidth) && !@ball[:resetting]
			# Помечаем, что мяч перезапущен, чтобы не зациклиться
			@ball[:resetting] = true;
			# Даём секунду на подготовку игрокам
			if @ball[:x] < 0 then @players[1].inc_score else @players[0].inc_score end
			sleep(1)
			#Всё, мяч в игре
			@ball[:resetting] = false;
			# Снова запускаем его из центра
			@ball[:x] = @cwidth / 2;
			@ball[:y] = @cheight / 2;
		end
	end

	def game_engine
		@players.each do |p|
			p.reset_paddle_dy
		end
		if !@game
			@status = "finished"
		end
		if @players[0].status == "waiting" || @players[1].status == "waiting"
			@status = "waiting"
		end

		# @left_paddle[:y] = @players[0].move(@ball, @grid, @maxPaddleY)
		# @right_paddle[:y] = @players[1].move(@ball, @grid, @maxPaddleY)
		@players.each do |p|
			p.move(@ball, @grid, @maxPaddleY)
		end

		updateballpos

		if @players.any? { |p| p.score.to_i == 5}
			finish_game
		end
		send_config
	end

end

class Game < ApplicationRecord

    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 10}, uniqueness: true

    # RELSTIVES FOR PLAYERS
    belongs_to :player1, class_name: :User, required: true
    belongs_to :player2, class_name: :User, required: false

	@@Gamelogics = Hash.new

	def mysetup
		@@Gamelogics[self.id] = Gamelogics.new(self)
		# p "SALAM"
		# p @@Gamelogics[id]
	end

	def send_config
		if @@Gamelogics[id]
			@@Gamelogics[id].send_config
		end
	end
	
	def get_gamelogic
		@@Gamelogics[id]
	end

	def add_input(action, user_id)
		if @@Gamelogics[id]
			# p "HERE WE SEE ID #{id}"
			@@Gamelogics[id].validate_action(action, user_id, id)
		end
	end

	def toggle_players_ingame_status
		self.player1.is_ingame = !self.player1.is_ingame
		self.player1.save!
		if self.player2
			self.player2.is_ingame = self.player2.is_ingame
			self.player2.save!
		end
	end

	def mydestructor
		@@Gamelogics = nil
		# GameRoomChannel.broadcast_to(self, {
		# 	action: "redirect_after_destroy_room"
		# })
		# p "this game is end"
	end
end
