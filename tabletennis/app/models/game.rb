class Ball
	def initialize(canvas_width, canvas_height, extra_speed)
		@mult_value = 1.1
		@mult_value = 1.5 if extra_speed
		@radius = 5
		@posx = canvas_width / 2
		@posy = canvas_height / 2
		@canvas_width = canvas_width
		@canvas_height = canvas_height
		@turncounter = 0
		@xvelocity = 5

		if rand(1..2) == 1
			@xvelocity *= -1
		end
		@yvelocity = [2.5, 2.5 * rand(1..3) / 2].max
	end

	def updatepos(players)
		@posx += @xvelocity
		@posy += @yvelocity
		if (@xvelocity < 0 and players[0].paddle.get_hit(self)) or (@xvelocity > 0 and players[1].paddle.get_hit(self))
			@xvelocity *= -@mult_value
			@turncounter += 1
			@yvelocity *= @mult_value * rand(1..3) / 2
		end
		if @posy < @radius or @posy > @canvas_height - @radius
			@yvelocity *= -1
		end
		@turncounter
	end

	def reset
		@posx = @canvas_width / 2
		@posy = @canvas_height / 2
		@xvelocity = 5
		if rand(1..2) == 1
			@xvelocity *= -1
		end
		@yvelocity = [2.5, 2.5 * rand(1..3) / 2].max
	end

	def posx
		@posx
	end
	def posy
		@posy
	end
	def nextpos
		[@posx.to_i + @xvelocity.to_i, @posy.to_i + @yvelocity.to_i]
	end
	def radius
		@radius
	end
	def xvelocity
		@xvelocity
	end
	def yvelocity
		@yvelocity
	end
end

class Paddle
	def initialize(id, x, canvas_width, canvas_height, long_paddles)
		@id = id
		@height = 30
		@height *= 1.5 if long_paddles
		@width = 15.0
		@velocity = 5
		@posx = x.to_i + (@width / 2)
		@posy = canvas_height / 2
		@canvas_width = canvas_width.to_i
		@canvas_height = canvas_height.to_i
		@startingx = @posx.to_i
	end

	def move(input)
		return unless input

		if input[:type] == "paddle_up"
			@posy -= @velocity.to_i
			@posy = [@posy.to_i, @height / 2].max
		elsif input[:type] == "paddle_down"
			@posy += @velocity.to_i
			@posy = [@posy.to_i, @canvas_height.to_i - (@height / 2)].min
		end
	end

	def get_hit(ball)
		if @id == 0 then paddle_frontx = @posx + @width / 2 else paddle_frontx = @posx - @width / 2 end
		return false unless paddle_frontx.between?([ball.posx, ball.nextpos[0]].min, [ball.posx, ball.nextpos[0]].max)
		xdiff_ball = ball.nextpos[0] - ball.posx
		ydiff_ball = ball.nextpos[1] - ball.posy
		delta = ydiff_ball / xdiff_ball
		y_would_cross = delta * (paddle_frontx - ball.posx) + ball.posy
		return true if y_would_cross.between?(@posy - @height / 2 - ball.radius, @posy + @height / 2 + ball.radius)
		false
	end

	def reset
		@posx = @startingx.to_i
		@posy = @canvas_height / 2
	end

	def posx
		@posx
	end
	def posy
		@posy
	end
	def width
		@width
	end
	def height
		@height
	end
	def velocity
		@velocity
	end
end

class Player
    attr_accessor :inputs


    def initialize(id, x, canvas_width, canvas_height, user, long_paddles)
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
        @paddle = Paddle.new(id, x, canvas_width, canvas_height, long_paddles)
        @inputs = Array.new
    end

    def ai_sim(ball)
		if ball.nextpos[1].to_i > @paddle.posy.to_i + (@paddle.height.to_i / 3).to_i
			@paddle.move({ type: "paddle_down", id: @left_right } )
		elsif ball.nextpos[1].to_i < @paddle.posy.to_i - (@paddle.height.to_i / 3).to_i
			@paddle.move({ type: "paddle_up", id: @left_right } )
		end
	end

	def name
		@name
	end
	def score
		@score
	end
	def inc_score
		@score += 1
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

	def toggle_ready
		return if @ai
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

	def move(ball)
		if @ai and rand(1..3) > 1
			ai_sim(ball)
		end
		if @inputs.length > 0
			@paddle.move(@inputs.pop)
		end
	end
end

class Gamelogics
    def initialize(game)
        @game = game
        @canvas_width = 200
        @canvas_height = 200
        @status = "running"
        @players = [
            Player.new(0, 5, @canvas_width, @canvas_height, @game.player1, @game.long_paddles),
            Player.new(1, @canvas_width - 20, @canvas_width, @canvas_height, @game.player2, @game.long_paddles),
        ]
        @winner = "TBD"
        @msg = nil
        @turn = 0
        @ball = Ball.new(@canvas_width, @canvas_height, game.extra_speed)
    end

    def score
        if @ball.posx <= 0 then @players[1].inc_score else @players[0].inc_score end
        @players.each do |p|
            p.paddle.reset
        end
        @ball.reset
    end

    def finish_game
        @status = "finished"
    
        if @players[0].score.to_i > @players[1].score.to_i
            @winner = @players[0].nickname
            winner_id = @players[0].user_id
            loser_id = @players[1].user_id
        else
            @winner = @players[1].nickname
            winner_id = @players[1].user_id
            loser_id = @players[0].user_id
        end
        @msg = "#{@winner} wins!"
    end

    def sim_turn
		if @players[0].status == "waiting" or @players[1].status == "waiting"
			@status = "waiting"
			return
		end

		@players.each do |p|
			p.move(@ball)
		end
		@turn = @ball.updatepos(@players)

		if @ball.posx <= 0 or @ball.posx >= @canvas_width
			score
		end

		if @players.any? {|p| p.score.to_i == 5}
			finish_game
		end
		send_config
	end

    def send_config
        obj = {
            config: {
                status: @status,
                winner: @winner,
                message: @msg,
                canvas: {
                    width: @canvas_width,
                    height: @canvas_height
                },
                players: [
                    {
                        name: @players[0].name,
                        score: @players[0].score,
                        paddle: {
                            width: @players[0].paddle.width,
                            height: @players[0].paddle.height,
                            x: @players[0].paddle.posx,
                            y: @players[0].paddle.posy
                        }
                    },
                    {
                        name: @players[1].name,
                        score: @players[1].score,
                        paddle: {
                            width: @players[1].paddle.width,
                            height: @players[1].paddle.height,
                            x: @players[1].paddle.posx,
                            y: @players[1].paddle.posy
                        }
                    }
                ],
                ball: {
                    radius: @ball.radius,
                    x: @ball.posx,
                    y: @ball.posy
                }
            }
        }
        p "HELLO"
        GameRoomChannel.broadcast_to(Game.first, obj)
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

	def add_input(type, id, game_id)
		STDERR.puts "adding input, id is #{id}, type is #{type}"
		if type == "toggleReady"
			@players[id.to_i].toggle_ready
			if @players[0].status == "ready" and @players[1].status == "ready"
				GameJob.perform_later(game_id)
			end
		end
		@players[id].add_move({type: type, id: id})
	end

	def countdown
		@status = "countdown"
		3.downto(0) do |n|
			if n == 0 then @msg = nil else @msg = "Game starting in #{n}" end
			send_config
			sleep(1)
		end
		@status = "running"
		@msg = nil
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
    end

    def send_config
        if @@Gamelogics[id]
            @@Gamelogics[id].send_config
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

    def get_gamelogic
        @@Gamelogics[id]
    end

    def add_input(type, user_id)
		p "THIS IS ID GAME"
        if @@Gamelogics[id]
			p @@Gamelogics[id]
			p user_id
			p id
            @@Gamelogics[id].add_input(type, user_id, id)
        end
    end

    def mydestructor
        @@Gamelogic[id] = nil
    end

    def view_thread
        20.times {
            p "SALAM JACOCA1 GOD"
            sleep(1) 
        }
    end
end
