class GuildMember < ApplicationRecord
    belongs_to :user
    belongs_to :guild_member
end
