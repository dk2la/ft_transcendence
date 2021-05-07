class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:show, :destroy]

  def index
    @chat_rooms = ChatRoom.all
  end

  def show
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)

    if @chat_room.save
      redirect_to @chat_room, notice: 'Room was successfully created.'
    else
      render :new, alert: "#{@chat_room.errors.full_messages.join('; ')}"
    end
  end

  def update
    if @chat_room.update(chat_room_params)
      redirect_to @chat_room, notice: 'Room was successfully created.'
    else
      render :new, alert: "#{@chat_room.errors.full_messages.join('; ')}"
    end
  end

  def destroy
    @chat_room.destroy
    redirect_to chat_rooms, notice: "Room successfully destroyed!"
  end

  private

  def set_chat_room
    @chat = ChatRoom.find(params[:id])
  end

  def chat_room_params
    p params
    params.require(:chat_room).permit(:name)
  end
end
