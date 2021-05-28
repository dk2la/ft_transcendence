class GuildWarController < ApplicationController
    before_action :check_if_exists, only: [:create]

    # todo:
    # 1. points to both guilds
    # 2. invite system
    # 3. guild war end time

    def create
        p "PARAMS: #{params}"
        id1 = params[:ids][:id1].to_i
        id2 = params[:ids][:id2].to_i
        @g1 = Guild.all.find_by(id: id1).name
        @g2 = Guild.all.find_by(id: id2).name
        if params[:is_delay_war]
          time =params[:begin_date] + " " + params[:begin_time]
        else
          time = nil
        end
        @invitation = GuildWar.new(war_time_begin: time, sender_guild_id: id1, recipient_guild_id: id2, is_delay_war: params[:begin_from],
                                  is_delay_war: params[:is_delay_war], tournament_enabled: params[:tournament_enabled],
                                  add_ones: params[:add_ones], max_ignored_invites: params[:max_ignored_invites][:"{:in=>1.0..20.0, :step=>1}"], 
                                  max_time_of_ignoring_battle: params[:max_time_of_ignoring_battle][:"{:in=>1.0..20.0, :step=>1}"],
                                  casual_enabled: params[:casual_enabled], ladder_enabled: params[:ladder_enabled])
        @invitation.status = 'pending'
        @invitation.save
        redirect_to show_war_path(id1: id1, id2: id2)
    end

    def configure
        id1 = params[:ids][:id1].to_i
        id2 = params[:ids][:id2].to_i
        @g1 = Guild.all.find_by(id: id1)
        @g2 = Guild.all.find_by(id: id2)
    end

    def destroy
      invitation = GuildWar.find(params[:invitation_id])
      invitation.update(status: "rejected")
      invitation.destroy
      redirect_to guilds_path(invitation.recipient_guild)
    end
    
    def update
      invitation = GuildWar.find(params[:invitation_id])
      p current_user.guild
      invitation.update(status: "confirmed")
      invitation.war_time_begin = Time.now.to_i
      invitation.war_time_end = Time.now.to_i + 300
      invitation.save
      redirect_to guilds_path(invitation.recipient_guild)
      GuildWarLifecycleJob.set(wait: 2.minutes).perform_later(invitation)
    end

    def check_if_exists
      id1 = params[:ids][:id1].to_i
      id2 = params[:ids][:id2].to_i

      if GuildWar.where(sender_guild_id: id1, recipient_guild_id: id2).empty? == false
        redirect_to show_war_path(id1: id1, id2: id2), allert: 'War already exists'
      elsif GuildWar.where(sender_guild_id: id2, recipient_guild_id: id1).empty? == false
        redirect_to show_war_path(id1: id1, id2: id2), allert: 'War already exists'
      end
    end

    def show
      @g1 = Guild.all.find_by(id: params[:id1])
      @g2 = Guild.all.find_by(id: params[:id2])

      if GuildWar.where(sender_guild_id: @g1.id, recipient_guild_id: @g2.id).empty? == false
        @gw = GuildWar.find_by(sender_guild_id: @g1.id, recipient_guild_id: @g2.id)
      elsif GuildWar.where(sender_guild_id: @g2.id, recipient_guild_id: @g1.id).empty? == false
        @gw = GuildWar.find_by(sender_guild_id: @g2.id, recipient_guild_id: @g1.id)
      end

    end
end
