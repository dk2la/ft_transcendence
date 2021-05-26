class GamesController < ApplicationController
  before_action :set_params
	skip_before_action :verify_authenticity_token
  before_action :set_game, only: [:show]
  before_action :check_game_member, only: [:new, :create]
  # after_action :draw_rules, only: [:show], if: -> { @game.player1 && @game.player2 }

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def show
    # @game.send_config
    # Thread.new do
    #   Rails.application.executor.wrap do
    #     @game.view_thread
    #   end
    # end
  end

  # def draw_rules
  #   GameRoomChannel.broadcast_to(@game, {
  #       action: "draw_rules",
  #       title: "#{@game.id}",
  #     })
  # end

  def create
    param = params.require(:game).permit(:name, :background, :long_paddles)
    game = Game.create(name: param["name"], background: param["background"], player1: current_user, long_paddles: false)
    # game.mysetup
    if game.save
      redirect_to game, notice: "Game successfully created"
    else
      redirect_to new_game_path, alert: "#{game.errors.full_messages.join('; ')}"
    end
  end

  def create_ladder
    # queueing_users = User.where(is_queueing: true).where.not(id: current_user.id)
    # if queueing_users.length > 0
    #   op = queueing_users.first
    #   op.update(is_queueing: false)
    #   ladder = Game.find_by(id: )
    #   ladder.mysetup
    #   ladder.save
    #   RedirectChannel.broadcast_to(current_user, {
    #     action: "redirect",
    #     id: ladder.id
    #   })
    #   RedirectChannel.broadcast_to(op, {
    #     action: "redirect",
    #     id: ladder.id
    #   })
    #   render json: { status: "Start play"}, status: :ok
    # else
      current_user.update(is_queueing: true)
      current_user.save
      ladder = Game.new(name: ('a'..'z').to_a.shuffle[0..7].join, player1: current_user, name_player1: current_user.nickname, gametype: "ladder")
      ladder.save
      redirect_to ladder, notice: "Welcome to ladder game #{ladder.name}"
    # end
  end

  def join_to_game
    game = 1
    @game = Game.find(params[:id])
    if Game.where(player1: current_user, is_finished: false).empty? == false || Game.where(player2: current_user, is_finished: false).empty? == false
      if Game.where(player1: current_user, is_finished: false).empty? == false
        Game.where(player1: current_user, is_finished: false).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      elsif Game.where(player2: current_user, is_finished: false).empty? == false
        Game.where(player2: current_user, is_finished: false).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      end
    elsif @game[:player1_id] != current_user.id && @game[:player2_id] == nil
      @game.update(player2_id: current_user.id)
      @game.mysetup
      @game.save
      redirect_to @game, notice: "Successfully join to game #{@game.name}"
    else
      redirect_to @game, alert: "You already in game #{@game.name}, just play"
    end
    ga = current_user.guild.anagram if current_user.guild
    GameRoomChannel.broadcast_to(@game, {
        action: "draw_players",
        title: "#{@game.id}",
        added_user: current_user,
        guild_anagram: ga
      })
    p "YA TUTA"
  end

  def leave_from_game
    @game = Game.find(params[:id])
    if @game.player1 == current_user
      @game.destroy
      GameRoomChannel.broadcast_to(@game, {
        action: "redirect_after_destroy_room",
        title: "#{@game.id}",
      })
      redirect_to games_path, notice: "Successfully leave from game #{@game.name}, child :))"
    elsif @game.player2 == current_user
      @game.update(player2: nil)
      redirect_to games_path, notice: "Successfully leave from game #{@game.name}, child :))"
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def game_params
    p params
    p params.require(:game).permit(:name, :background)
  end

  def check_game_member
    game = 1
    if Game.where(player1: current_user, is_finished: false).empty? == false || Game.where(player2: current_user, is_finished: false).empty? == false
      if Game.where(player1: current_user, is_finished: false).empty? == false
        Game.where(player1: current_user, is_finished: false).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      elsif Game.where(player2: current_user, is_finished: false).empty? == false
        Game.where(player2: current_user, is_finished: false).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      end
    end
  end

  def set_params
		current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
	end

end
