class Guild < ApplicationRecord
    has_many :guild_members, dependent: :destroy
    has_many :users, :through => :guild_members
    has_many :invitations
    has_one  :guild_war, class_name: :GuildWar, required: false
    has_many :pending_invitations, -> { where status: "rejected" }, class_name: 'GuildWar', foreign_key: 'recipient_guild'
    
    def show_guild_war
        guild_send_inv = GuildWar.where(sender_guild: id, status: "confirmed").pluck(:recipient_guild)
        guild_got_inv = GuildWar.where(recipient_guild: id, status: "confirmed").pluck(:sender_guild)
        ids = guild_send_inv + guild_got_inv
        Guild.where(id: ids)
    end
    
    def war_with?(guild)
        GuildWar.confirmed_record?(id, guild.id)
    end
    
    def send_war_invitation(guild)
        invitations.create(recipient_guild: guild.id)
    end
    
    ANAGRAM_VALIDATE_REGEX = /[A-Z]/
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 5, maximum: 15}, uniqueness: true
    validates :anagram, presence: true, format: { with: ANAGRAM_VALIDATE_REGEX }, length: {minimum: 4, maximum: 5}, uniqueness: true
    validates :description, presence: true, length: {minimum: 3, maximum: 300}
    
    def check_current_guild?(cur, guild)
        if cur.guild.id == guild.id
            return true
        end
        return false
    end
    
    def user_owner?(cur, guild)
        if guild.check_current_guild?(cur, guild) && cur.guild_member.user_role == 2
            return true
        end
        return false
    end
    
    def check_member_role?(cur, guild)
        if guild.check_current_guild?(cur, guild) && cur.guild_member.user_role == 0
            return true
        end
        return false
    end
    
    def check_member_officer?(cur, guild)
        if guild.check_current_guild?(cur, guild) && cur.guild_member.user_role == 1
            return true
        end
        return false
    end
end
