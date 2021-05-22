<<<<<<< HEAD
class ChatRoom < ApplicationRecord
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
   
    # RELATIVES FOR MEMBERS
    has_many :room_members, dependent: :destroy
    has_many :users, :through => :room_members
    has_one :owner, -> { where(member_role: 2) }, class_name: :RoomMember
    has_many :moderators, -> { where(member_role: 1) }, class_name: :RoomMember
    has_many :members, -> { where(member_role: 0) }, class_name: :RoomMember
=======
include ActionView::Helpers::UrlHelper

class ChatRoom < ApplicationRecord
    NAME_VALIDATE_REGEX = /[a-zA-Z ]/
    
    # RELATIVES FOR MEMBERS
    has_many :room_members, dependent: :destroy
    has_many :users, :through => :room_members
    has_one :owner, -> { where(member_role: "owner") }, class_name: :RoomMember
    has_many :moderators, -> { where(member_role: "moderator") }, class_name: :RoomMember
    has_many :members, -> { where(member_role: "member") }, class_name: :RoomMember
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    # has_many :muteds, -> { where(muted: true) }, class_name: :RoomMember
    has_many :banned_users

    #RELATIVE FOR MESSAGES
    has_many :messages

    #RELATIVE FOR MUTED
    has_many :muted_users

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
<<<<<<< HEAD
        if room_member[:member_role] == 2
=======
        if room_member.member_role == "owner"
            return true
        end
        return false
    end

    def room_moderator?(cur, chat_room)
        room_member = cur.room_members.find_by(chat_room_id: chat_room.id)
        if room_member.member_role == "moderator"
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
            return true
        end
        return false
    end

    def just_room_member?(cur, chat_room)
        room_member = cur.room_members.find_by(chat_room_id: chat_room.id)
<<<<<<< HEAD
        if room_member[:member_role] == 0
=======
        if room_member.member_role == "member"
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
            return true
        end
        return false
    end

    def user_banned?(cur, chat_room)
        if chat_room.banned_users.find_by(user_id: cur.id)
            return true
        end
        return false
    end

    def member_muted?(cur, chat_room)
        if chat_room.muted_users.find_by(user_id: cur.id)
            return true
        end
        return false
    end
<<<<<<< HEAD
=======

    def user_block(added_user, chat_room)
        link = link_to('View profile', Rails.application.routes.url_helpers.list_player_path(added_user.id))
        if chat_room.room_members.find_by(user_id: added_user.id)
            rm = chat_room.room_members.find_by(user_id: added_user.id)
            if rm.member_role == "member" && added_user.guild
                html = ApplicationController.render partial: "chat_rooms/list_members", locals: { chat_room: chat_room, added_user: added_user }, formats: [:html]
            else
                "<td>#{added_user.nickname}</td><td>\"None\"</td><td>#{added_user.rating}</td>"
            end
        end
    end

    def verificate_user?(cur)
        if self.room_members && self.room_members.find_by(user_id: cur.id)
            return true
        end
        return false
    end

    def verificate_password?(password)
        if self.password && self.password == password
            return true
        end
        return false
    end

    def is_private?
        if self.private == true
            return true
        end
        return false
    end
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
end
