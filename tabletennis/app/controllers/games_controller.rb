class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def show
  end

  def create
    game = Game.new(game_params)
    
    if game.save
      redirect_to game, notice: "Game successfully created"
    else
      redirect_to game_new_path, alert: 'Game not created because some fields wrong'
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
  
  # Only allow a list of trusted parameters through.
  def game_params
    p params
    p params.require(:game).permit(:name)
  end
end
