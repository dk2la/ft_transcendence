class ChatRoom < ApplicationRecord
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
   
    # RELATIVES FOR MEMBERS
    has_many :room_members, dependent: :destroy
    has_many :users, :through => :room_members
    has_one :owner, -> { where(member_role: 2) }, class_name: 'Room_member'
    has_many :moderators, -> { where(member_role: 1) }, class_name: 'Room_member'
    has_many :members, -> { where(member_role: 0) }, class_name: 'Room_member'
    has_many :banned_users

    #RELATIVE FOR MESSAGES
    has_many :messages

    #Validates
    validates :name, presence: true, format: {with: NAME_VALIDATE_REGEX }, length: {minimum: 2, maximum: 20}, uniqueness: true

    def room_member?(cur, chat_room)
        if chat_room.room_members.find_by(user_id: cur)
            return false
        end
        return true
    end

    def room_owner?(cur, chat_room)
        room_member = cur.room_members.find_by(chat_room_id: chat_room.id)
        if room_member[:member_role] == 2
            return true
        end
        return false
    end
end
