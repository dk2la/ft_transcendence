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
