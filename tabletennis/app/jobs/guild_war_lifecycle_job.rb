class GuildWarLifecycleJob < ApplicationJob
  queue_as :default

  def perform(war, flag)
    p "IN JOB"
    p flag
    if flag == 0
      war.update(status: "confirmed")
    elsif flag == 1
      war.update(status: "ended")
      if war.sender_victoies > war.recipient_victories
        Guild.find_by(id: war.sender_guild_id).update(rating: Guild.find_by(id: war.sender_guild_id).rating + war.bank_points)
        Guild.find_by(id: war.recipient_guild_id).update(rating: Guild.find_by(id: war.recipient_guild_id).rating - war.bank_points)
      elsif war.sender_victoies < war.recipient_victories
        Guild.find_by(id: war.sender_guild_id).update(rating: Guild.find_by(id: war.sender_guild_id).rating - war.bank_points)
        Guild.find_by(id: war.recipient_guild_id).update(rating: Guild.find_by(id: war.recipient_guild_id).rating + war.bank_points)
      end

    end
    # war.destroy
  end
end
