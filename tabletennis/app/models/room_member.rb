class RoomMember < ApplicationRecord
<<<<<<< HEAD
=======
    enum member_role: [:member, :moderator, :owner]
    
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    belongs_to :user
    belongs_to :chat_room
end
