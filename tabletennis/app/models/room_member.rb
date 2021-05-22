class RoomMember < ApplicationRecord
    enum member_role: [:member, :moderator, :owner]
    
    belongs_to :user
    belongs_to :chat_room
end
