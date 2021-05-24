class GuildWarController < ApplicationController
    def create
        id1 = params[:ids][:id1].to_i
        id2 = params[:ids][:id2].to_i
        @g1 = Guild.all.find_by(id: id1).name
        @g2 = Guild.all.find_by(id: id2).name

        @invitation = GuildWar.new(sender_guild_id: id1, recipient_guild_id: id2)
        p Time.now.to_i
        @invitation.save
        
        # redirect_to guilds_path
    end
    
    #   def destroy
    #     invitation = Friendship.find(params[:invitation_id])
    #     invitation.destroy
    #     redirect_to profiles_path(current_user.id)
    #   end
    
      def update
        invitation = GuildWar.find(params[:invitation_id])
        p current_user
        invitation.update(confirmed: true)
        redirect_to guilds_path(invitation.id)
      end
end
