class GuildsController < ApplicationController
  def index
    @guilds = Guild.all
  end

  def new
    @guild = Guild.new
  end

  def create
    @guild = Guild.new(guild_params)
    guild_member = GuildMember.create(user: current_user, guild: @guild)

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
end

