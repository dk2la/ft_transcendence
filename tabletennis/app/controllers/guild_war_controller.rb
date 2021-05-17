class GuildWarController < ApplicationController
    def create
        id1 = params[:ids][:id1]
        id2 = params[:ids][:id2]
        @g2 = Guild.all.find_by(id: id2).name
        @invitation = GuildWar.new(sender_guild: id1, recipient_guild: id2, war_time_begin: Time.now.to_i)
        p Time.now.to_i
        @invitation.save
        # redirect_to guilds_path
    end
    
    #   def destroy
    #     invitation = Friendship.find(params[:invitation_id])
    #     invitation.destroy
    #     redirect_to profiles_path(current_user.id)
    #   end
    
    #   def update
    #     invitation = Friendship.find(params[:invitation_id])
    #     p current_user
    #     invitation.update(confirmed: true)
    #     redirect_to profiles_path(invitation.friend_id)
    #   end
end
