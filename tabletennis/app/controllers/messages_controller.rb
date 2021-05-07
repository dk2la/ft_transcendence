class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show]

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

    unless @message.save
      flash.now[:alert] = "#{@message.errors.full_messages.join('; ')}"
    end

    SendMessageJob.perform(@message)
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
