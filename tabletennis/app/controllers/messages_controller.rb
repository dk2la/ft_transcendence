class MessagesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_message, only: [:show, :edit]

  def index
      @messages = Message.all
    end
  
    def show
    end

    def new
      @message = Message.new
    end
  
    def edit
    end
  
    def create
      p "I AM HERE"
      p message_params
      @chat_room = ChatRoom.find(message_params[:chat_room_id])
      @message = Message.create(content: message_params[:content], user: current_user, chat_room: @chat_room)
      if @message.save
        @chat_room.room_members.each do |member|
          ChatRoomChannel.broadcast_to(member.user, {
            action: "send_message",
            title: "#{@chat_room.id}",
            msg_id: @message.id,
            body: @message.str(member.user)
          })
        end
        render json: { status: "Succesfully sent chat_room message" }, status: :ok
      else
        render json: { error: "Error, couldn't save your chat_room message" }, status: :bad_request
      end
    end

    private

    def set_message
        @message = Message.find(params[:id])
    end

    def message_params
        params.require(:message).permit(:content, :user_id, :chat_room_id)
    end
end
