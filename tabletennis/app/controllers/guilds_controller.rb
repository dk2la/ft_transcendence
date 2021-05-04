class GuildsController < ApplicationController
  # todo добавить защиту на make officer, remove officer, kick_member_from_guild
  before_action :authenticate_user!
  before_action :set_guild, only: [:set_guild_member_officer, :accept_to_guild, :check_user_role, :show, :edit]
  before_action :check_guild_mem, only: [:new, :create, :accept_to_guild]
  before_action :check_user_role, only: [:edit]

  def index
    @guilds = Guild.all
    @guilds = @guilds.sort_by(&:rating).reverse
  end

  def new
    @guild = Guild.new
  end

  def show
    @gm = @guild.guild_members
    @owner = @guild.guild_members.where(user_role: 2)
  end

  def edit
  end

  def create
    guild = Guild.new(guild_params)
    
    if guild.save
      guild_members = GuildMember.create(user_role: 2, user: current_user, guild: guild)
      redirect_to guild, notice: "Guild successfully created"
    else
      redirect_to new_guild_path, alert: 'Guild not created because some fields wrong'
    end
  end
  
  def accept_to_guild
    guild_members = GuildMember.create(user_role: 0, user: current_user, guild: @guild)
    redirect_back fallback_location: { action: "show" }, notice: "You are join to this guild"
  end
  
  def leave_from_guild
    if current_user.guild_member[:user_role] == 2
      guild = Guild.find(params[:id])
      guild.destroy
      redirect_to guilds_path, notice: "Guild has been destroyed"
    else
      current_user.guild_member.destroy
      redirect_to guilds_path, notice: "You are succsessfully leave from this guild"
    end
  end

  def set_officer
    p params
    cur = User.find(params[:id])
    unless cur.guild.check_member_role?(cur, cur.guild)
      redirect_to guild_path(cur.guild), alert: "User cannot be an officer #{cur.nickname}"
    else
      cur.guild_member.update(user_role: 1)
      redirect_to guild_path(cur.guild), notice: "Successfully set officer #{cur.nickname}"
    end
  end

  def remove_from_officer
    cur = User.find(params[:id])
    unless cur.guild.check_member_officer?(cur, cur.guild)
      redirect_to guild_path(cur.guild), alert: "User cannot be remove from officer #{cur.nickname}"
    else
      cur.guild_member.update(user_role: 0)
      redirect_to guild_path(cur.guild), notice: "Successfully remove from officer #{cur.nickname}"
    end
  end

  def kick_member_from_guild # todo сделать так, чтобы офицер не мог кикать сам себя
    cur = User.find(params[:id])
    unless cur.guild.user_owner?(cur, cur.guild)
      cur.guild_member.destroy
      redirect_to guild_path(cur.guild), notice: "Successfully remove member from guild #{cur.nickname}"
    else
      redirect_to guild_path(cur.guild), alert: "This is owner"
    end
  end
  private

  def check_user_role
    unless current_user.guild && current_user.guild.user_owner?(current_user, @guild) # todo добавить alert на то что чел не в гильдии
      redirect_to guild_path, alert: "You are not owner for edit"
    end
  end

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

