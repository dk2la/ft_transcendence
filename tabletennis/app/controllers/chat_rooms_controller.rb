class ChatRoomsController < ApplicationController
    before_action :authenticate_user!
<<<<<<< HEAD
    before_action :set_chat_room, only: [:show, :update, :leave_from_room]
=======
    before_action :set_chat_room, only: [:update, :leave_from_room]
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed

    def index
        @chat_rooms = ChatRoom.all
    end

    def show
<<<<<<< HEAD
    end

    def edit
=======
        @chat_room = ChatRoom.find(params[:id])
        if @chat_room.direct == true
            if @chat_room.verificate_user?(current_user)
                flash[:notice] = "#{current_user.nickname}, welcome to direct #{@chat_room.name}"
            else
                redirect_to chat_rooms_path, alert: "#{@chat_room.id}, is direct, i mean not for you)"
            end
        else
            flash[:notice] = "View #{@chat_room.name}"
        end
    end

    def edit
        @chat_room = ChatRoom.find(params[:id])
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end

    def new
        @chat_room = ChatRoom.new
    end

<<<<<<< HEAD
=======
    def remove_password
        @chat_room = ChatRoom.find(params[:id])
        @chat_room.update(passcode: nil, private: false)
        redirect_to @chat_room, notice: "Successfyllt removed password form #{@chat_room.name} room"
    end

>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    def join_chat_room
        @chat_room = ChatRoom.find(params[:id])
        if @chat_room.user_banned?(current_user, @chat_room)
            redirect_to chat_rooms_path, alert: "You have no access to this room, because you banned"
        elsif @chat_room.room_member?(current_user.id, @chat_room)
<<<<<<< HEAD
            room_member = RoomMember.create(user_id: current_user.id, chat_room_id: @chat_room.id, member_role: 0)
            redirect_to @chat_room, notice: "Successfully join to chat #{@chat_room.name}"
            ActionCable.server.broadcast "chat_room_channel_#{@chat_room.id}", {member: room_member, action: "join"}
        else
            redirect_to chat_room_path(@chat_room.id), alert: "You already in chat  #{@chat_room.name}"
        end
=======
            if @chat_room.is_private?
                p "SALAMCHIK"
                flash[:notice] = "Insert password"
            else
                room_member = RoomMember.create(user_id: current_user.id, chat_room_id: @chat_room.id, member_role: 0)
                redirect_to @chat_room, notice: "Successfully join to chat #{@chat_room.name}"
            end
        else
            redirect_to chat_room_path(@chat_room.id), alert: "You already in chat  #{@chat_room.name}"
        end
        if @chat_room[:private] == false && !@chat_room.banned_users.find_by(user_id: current_user.id)
            ga = current_user.guild.anagram if current_user.guild
            @chat_room.room_members.each do |member|
                if current_user != member.user
                    ChatRoomChannel.broadcast_to(member.user, {
                        action: "join_chat_room",
                        title: "#{@chat_room.id}",
                        added_user: current_user,
                        receiver_role: member.member_role,
                        receiver_id: member.user.id,
                        chat_id: @chat_room.id,
                        guild_anagram: ga
                    })
                end
            end
        end
        p "YA TUTA"
    end

    def verificate_password
        param = params.require(:chat_room).permit(:id, :passcode)
        pass = param["passcode"]
        @chat_room = ChatRoom.find(param["id"])
        p @chat_room
        if Base64.strict_encode64(pass) == @chat_room[:passcode]
            room_member = RoomMember.create(user_id: current_user.id, chat_room_id: @chat_room.id, member_role: 0)
            unless @chat_room.banned_users.find_by(user_id: current_user.id)
                ga = current_user.guild.anagram if current_user.guild
                @chat_room.room_members.each do |member|
                    if current_user != member.user
                        ChatRoomChannel.broadcast_to(member.user, {
                            action: "join_chat_room",
                            title: "#{@chat_room.id}",
                            added_user: current_user,
                            receiver_role: member.member_role,
                            receiver_id: member.user.id,
                            chat_id: @chat_room.id,
                            guild_anagram: ga
                        })
                    end
                end
            end
            redirect_to chat_room_path(@chat_room.id), notice: "Welcome to private room #{@chat_room.name}"
        else
            redirect_to chat_rooms_path, alert: "Wrong pass for #{@chat_room.name}"
        end
        p "KEKOS"
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end

    def create
        @chat_room = ChatRoom.new(chat_room_params)
        
        if @chat_room.save
            room_members = RoomMember.create(user_id: current_user.id, chat_room_id: @chat_room.id, member_role: 2)
            redirect_to @chat_room, notice: "Chat room #{@chat_room.name}, successfully created!"
        else
            redirect_to chat_rooms_path, alert: "#{@chat_room.errors.full_messages.join('; ')}"
        end
    end

    def update
        if @chat_room.update(chat_room_params)
<<<<<<< HEAD
            redirect_to @chat_room, notice: "Chat room #{@chat_room}, successfully updated!"
=======
            if @chat_room.update(passcode: Base64.strict_encode64(@chat_room.passcode))
                redirect_to @chat_room, notice: "Chat room #{@chat_room}, successfully updated!"
            end
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
        else
            redirect_to chat_rooms_path, alert: "#{@chat_room.errors.full_messages.join('; ')}" #todo сделать редирект на edit method
        end
    end

    def leave_from_room
        if @chat_room.room_owner?(current_user, @chat_room)
<<<<<<< HEAD
=======
            @chat_room.room_members.each do |member|
                if current_user != member.user
                    ChatRoomChannel.broadcast_to(member.user, {
                        action: "leave_chat_room_owner",
                        title: "#{@chat_room.id}",
                        leave_user_id: current_user.id
                    })
                end    
            end
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
            @chat_room.destroy
            redirect_to chat_rooms_path, notice: "Chat room #{@chat_room.name} successfully removed"
        else
            current_user.room_members.find_by(chat_room_id: @chat_room.id).destroy
            redirect_to chat_rooms_path, notice: "User #{current_user.nickname}, successfully leaved!"
        end
<<<<<<< HEAD
=======
        @chat_room.room_members.each do |member|
            if current_user != member.user
                ChatRoomChannel.broadcast_to(member.user, {
                    action: "leave_chat_room",
                    title: "#{@chat_room.id}",
                    leave_user_id: current_user.id
                })
            end
        end
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end

    def set_moderator
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        unless @chat_room.just_room_member?(cur, @chat_room)
            redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname} already owner or moderator!"
        else
            cur.room_members.find_by(chat_room_id: @chat_room.id).update(member_role: 1)
            redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname} successfully approve to moderator"
        end
    end

    def remove_moderator
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        if @chat_room.just_room_member?(cur, @chat_room)
            redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname} already member!"
        else
            cur.room_members.find_by(chat_room_id: @chat_room.id).update(member_role: 0)
            redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname} successfully removed from moderator"
        end
    end

    def mute_member #todo add table with muted users
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        cu = User.find(params[:current_id])
        unless @chat_room.room_owner?(cu, @chat_room)
            redirect_to chat_room_path(@chat_room.id), alert: "#{cu.nickname}, not owner or moderator"
        else
            if @chat_room.room_owner?(cur, @chat_room)
                redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname}, is owner!"
            else
                muted = MutedUser.new(user_id: cur.id, chat_room_id: @chat_room.id)
                if !@chat_room.member_muted?(cur, @chat_room) && muted.save
<<<<<<< HEAD
                    redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname}, successfully muted" 
=======
                    redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname}, successfully muted for you" 
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
                else
                    redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname}, already muted"
                end
            end
        end
<<<<<<< HEAD
=======
        ChatRoomChannel.broadcast_to(cur, {
            action: "mute_member_from_owner",
            title: "#{@chat_room.id}",
            banned_user: cur
        })
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end

    def umute_member
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        cu = User.find(params[:current_id])
        unless @chat_room.room_owner?(cu, @chat_room)
            redirect_to chat_room_path(@chat_room.id), alert: "#{cu.nickname}, not owner or moderator"
        else
            if @chat_room.member_muted?(cur, @chat_room)
<<<<<<< HEAD
=======
                ChatRoomChannel.broadcast_to(cur, {
                    action: "unmute",
                    title: "#{@chat_room.id}",
                    banned_user: cur
                })
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
                @chat_room.muted_users.find_by(user_id: cur.id).destroy
                redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname}, successfully unmuted"
            else
                redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname}, was not be muted"
            end
        end
    end

    def ban_user #todo дописать метод проверяющий owner или нет, для before_action, если нет то кинет алерт
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        if @chat_room.room_owner?(cur, @chat_room)
            redirect_to chat_room_path(@chat_room.id), alert: "#{cur.nickname}, is owner!"
        else
            banned_user = BannedUser.new(user_id: cur.id, chat_room_id: @chat_room.id)
            if banned_user.save
                @chat_room.room_members.find_by(user_id: cur.id).destroy
                redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname}, successfully banned"
            else
                redirect_to chat_room_path(@chat_room.id), alert: "Fuck you"
            end
        end
<<<<<<< HEAD
=======
        ga = cur.guild.anagram if cur.guild
        @chat_room.room_members.each do |member|
            if cur != member.user
                ChatRoomChannel.broadcast_to(member.user, {
                    action: "ban_user_append",
                    title: "#{@chat_room.id}",
                    banned_user: cur,
                    receiver_id: member.user.id,
                    chat_id: @chat_room.id,
                    guild_anagram: ga
                })
            end
        end
        ChatRoomChannel.broadcast_to(cur, {
                    action: "ban_user_redirect",
                    title: "#{@chat_room.id}",
                    banned_user: cur
        })
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end

    def unban_user
        @chat_room = ChatRoom.find(params[:chat_id])
        cur = User.find(params[:id])
        @chat_room.banned_users.find_by(user_id: cur.id).destroy
        redirect_to chat_room_path(@chat_room.id), notice: "#{cur.nickname}, successfully unbanned"
    end

<<<<<<< HEAD
=======
    def block_user
        @chat_room = ChatRoom.find(params[:chat_id])
        @target_user = User.find(params[:target_id])
        @current = User.find(params[:current_id])
        if @current.id == @target_user.id
            redirect_to @chat_room, alert: "Block your self? Seriously?"
        else
            if current_user.blocked_users.find_by(cur: @target_user)
                redirect_to @chat_room, alert: "#{@target_user.nickname}, already blocked"
            else
                block_user = BlockedUser.new(user: @current, cur: @target_user)
                if block_user.save
                    redirect_to @chat_room, notice: "#{@target_user.nickname}, successfully blocked"
                else
                    redirect_to @chat_room, alert: "Something wrong"
                end
            end
        end
    end

    def unblock_user
        @chat_room = ChatRoom.find(params[:chat_id])
        @target_user = User.find(params[:target_id])
        @current = User.find(params[:current_id])
        if @current.id == @target_user.id
            redirect_to @chat_room, alert: "Again?"
        else
            bu = @current.blocked_users.find_by(cur: @target_user)
            if bu
                bu.destroy
                redirect_to @chat_room, notice: "#{@target_user.nickname}, successfully unblocked"
            else
                redirect_to @chat_room, alert: "#{@target_user.nickname}, not blocked"
            end
        end
    end

    def create_dm
        name = ('a'..'z').to_a.shuffle[0..7].join
        direct = ChatRoom.new(name: name, direct: true)
        direct_mate = User.find(params[:direct_mate])
        current = User.find(params[:current_id])
        if direct.save
            room_member_first = RoomMember.create(user_id: current_user.id, chat_room_id: direct.id, member_role: 0)
            room_member_second = RoomMember.create(user_id: direct_mate.id, chat_room_id: direct.id, member_role: 0)
            redirect_to direct, notice: "Chat room #{direct.name}, successfully created!"
        else
            redirect_to profiles_path, alert: "Something wrong, idk how that happends... "
        end
    end

>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    private
    
    def set_chat_room
        @chat_room = ChatRoom.find(params[:id])
    end

    def chat_room_params
<<<<<<< HEAD
        params.require(:chat_room).permit(:name)
=======
        params.require(:chat_room).permit(:name, :passcode, :private)
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
    end
end
