class ChatRoomsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_chat_room, only: [:show, :update, :join_chat_room]

    def index
        @chat_rooms = ChatRoom.all
    end

    def show

    end

    def edit
    end

    def new
        @chat_room = ChatRoom.new
    end

    def join_chat_room
        if @chat_room.room_member?(current_user.id, @chat_room)
            room_members = RoomMember.create(user_id: current_user.id, chat_room_id: @chat_room.id, member_role: 0)
            redirect_to @chat_room, notice: "Successfully join to chat #{@chat_room.name}"
        else
            redirect_to chat_room_path(@chat_room.id), alert: "You already in chat  #{@chat_room.name}"
        end
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
            redirect_to @chat_room, notice: "Chat room #{@chat_room}, successfully updated!"
        else
            redirect_to chat_rooms_path, alert: "#{@chat_room.errors.full_messages.join('; ')}" #todo сделать редирект на edit method
        end
    end

    def destroy
    end

    private
    
    def set_chat_room
        @chat_room = ChatRoom.find(params[:id])
    end

    def chat_room_params
        params.require(:chat_room).permit(:name)
    end
end
