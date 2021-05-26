class GuildWar < ApplicationRecord
    belongs_to :sender_guild, class_name: :Guild
    belongs_to :recipient_guild, class_name: :Guild

    def self.reacted?(id1, id2)
        case1 = !GuildWar.where(sender_guild_id: id1, recipient_guild_id: id2).empty?
        case2 = !GuildWar.where(sender_guild_id: id2, recipient_guild_id: id1).empty?
        case1 || case2
    end
    
    def self.confirmed_record?(id1, id2)
        case1 = !GuildWar.where(sender_guild: id1, recipient_guild: id2, status: "confirmed").empty?
        case2 = !GuildWar.where(sender_guild: id2, recipient_guild: id1, status: "confirmed").empty?
        case1 || case2
    end
    
    def self.find_guild_war(id1, id2)
        if GuildWar.where(sender_guild: id1, recipient_guild: id2, status: "confirmed").empty?
            GuildWar.where(sender_guild: id2, recipient_guild: id1, status: "confirmed")[0].id
        else
            GuildWar.where(sender_guild: id1, recipient_guild: id2, status: "confirmed")[0].id
        end
    end
end
