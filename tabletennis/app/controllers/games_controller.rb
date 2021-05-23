class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]
  before_action :check_game_member, only: [:new, :create]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def show
    # Thread.new do
    #   Rails.application.executor.wrap do
    #     @game.view_thread
    #   end
    # end
  end

  def create
    param = params.require(:game).permit(:name, :background)
    game = Game.new(name: param["name"], background: param["background"], player1: current_user)
    
    if game.save
      redirect_to game, notice: "Game successfully created"
    else
      redirect_to new_game_path, alert: "#{game.errors.full_messages.join('; ')}"
    end
  end

  def join_to_game
    game = 1
    @game = Game.find(params[:id])
    if Game.where(player1: current_user).empty? == false || Game.where(player2: current_user).empty? == false
      if Game.where(player1: current_user).empty? == false
        Game.where(player1: current_user).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      elsif Game.where(player2: current_user).empty? == false
        Game.where(player2: current_user).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      end
    elsif @game[:player1_id] != current_user.id && @game[:player2_id] == nil
      @game.update(player2_id: current_user.id)
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
    if Game.where(player1: current_user).empty? == false || Game.where(player2: current_user).empty? == false
      if Game.where(player1: current_user).empty? == false
        Game.where(player1: current_user).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      elsif Game.where(player2: current_user).empty? == false
        Game.where(player2: current_user).each do |g|
          game = g
        end
        redirect_to game, alert: "You already in game #{game.name}"
      end
    end
  end

end
