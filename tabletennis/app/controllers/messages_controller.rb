class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :update, :destroy]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.save

    SendMessageJob.perform_now(@message)
  end

  def update
      if @message.update(message_params)
        redirect_to @message, notice: 'Message was successfully updated.'
      end
  end

  def destroy
    @message.destroy
    redirect_to messages_path, notice: 'Message was successfully destroyed.'
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :user_id, :chat_room_id)
  end
end
