class GuildWarController < ApplicationController
    before_action :authenticate_user!
    before_action :check_if_exists, only: [:create]

    # todo:
    # 1. points to both guilds
    # 2. invite system
    # 3. guild war end time

    def create
        p "PARAMS: #{params}"
        id1 = params[:ids][:id1].to_i
        id2 = params[:ids][:id2].to_i
        @g1 = Guild.find_by(id: id1).name
        @g2 = Guild.find_by(id: id2).name
        if params[:is_delay_war]
          time =params[:begin_date] + " " + params[:begin_time]
        else
          time = nil
        end
        @invitation = GuildWar.new(war_time_begin: time, sender_guild_id: id1, recipient_guild_id: id2, is_delay_war: params[:begin_from],
                                  is_delay_war: params[:is_delay_war], casual_enabled: params[:casual_enabled],
                                  ladder_enabled: params[:ladder_enabled], status: "pending", bank_points: params[:bank_points].to_i, duration: params[:duration].to_i)
        if @invitation.save
          p "SALAMCH"
          p @invitation
        else
          p @invitation.errors.full_message.join('; ')
        end
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
      invitation.save
      redirect_to guilds_path(invitation.recipient_guild)
      invitation.update(status: "accepted")
      if (invitation.is_delay_war)
        GuildWarLifecycleJob.set(wait_until: (DateTime.parse(invitation.war_time_begin) - 3.hours)).perform_later(invitation, 0)
        GuildWarLifecycleJob.set(wait_until: (DateTime.parse(invitation.war_time_begin)- 3.hours + invitation.duration.minutes)).perform_later(invitation, 1)
      else
        invitation.update(status: "confirmed")
        GuildWarLifecycleJob.set(wait: invitation.duration.minute).perform_later(invitation, 1)
      end
    end

    def check_if_exists
      id1 = params[:ids][:id1].to_i
      id2 = params[:ids][:id2].to_i

      if GuildWar.where(sender_guild_id: id1, recipient_guild_id: id2, status: "confirmed").empty? == false || GuildWar.where(sender_guild_id: id1, recipient_guild_id: id2, status: "pending").empty? == false ||
        GuildWar.where(sender_guild_id: id1, recipient_guild_id: id2, status: "accepted").empty? == false 
        redirect_to show_war_path(id1: id1, id2: id2), alert: 'War already exists'
      elsif GuildWar.where(sender_guild_id: id2, recipient_guild_id: id1, status: "confirmed").empty? == false || GuildWar.where(sender_guild_id: id2, recipient_guild_id: id1, status: "pending").empty? == false ||
        GuildWar.where(sender_guild_id: id2, recipient_guild_id: id1, status: "accepted").empty? == false 
        redirect_to show_war_path(id1: id1, id2: id2), alert: 'War already exists'
      end
    end

    def show
      @g1 = Guild.find_by(id: params[:id1])
      @g2 = Guild.find_by(id: params[:id2])

      if GuildWar.where(sender_guild_id: @g1.id, recipient_guild_id: @g2.id).empty? == false
        @gw = GuildWar.where(sender_guild_id: @g1.id, recipient_guild_id: @g2.id).last
      elsif GuildWar.where(sender_guild_id: @g2.id, recipient_guild_id: @g1.id).empty? == false
        @gw = GuildWar.where(sender_guild_id: @g2.id, recipient_guild_id: @g1.id).last
      end

    end
end
