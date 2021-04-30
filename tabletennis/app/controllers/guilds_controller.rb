class GuildsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_guild, only: [:show]
  before_action :check_guild_mem, only: [:show, :new, :create]

  def index
    @guilds = Guild.all
    @guilds = @guilds.sort_by(&:rating).reverse
  end

  def new
    @guild = Guild.new
  end

  def show
    @guild = Guild.find(params[:id])
  end

  def create
    @guild = Guild.new(guild_params)
    guild_members = GuildMember.create(user_role: 2, user: current_user, guild: @guild)

    respond_to do |f|
      if @guild.save
        f.html { redirect_to @guild, notice: "Guild was successfully created." }
      else
        f.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guild
      @guild = Guild.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def guild_params
      p params
      p params.require(:guild).permit(:name, :anagram, :description, :rating)
    end

    def check_guild_mem
      if current_user.guild
        redirect_back fallback_location: { action: "index" }, alert: "you are already in guild"
      end
    end
end

