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
<<<<<<< HEAD
      p "HERE"
      p params
      @message = Message.new(message_params)
      @message.user = current_user
      
      chat = ChatRoom.find(message_params[:chat_room_id])
      if chat.muted_users.find_by(user_id: current_user.id)
        redirect_to chat_room_path(chat.id), alert: "You cannot be write, because you muted"
      else
        @message.save
        SendMessageJob.perform_later(@message)
=======
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
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed
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
