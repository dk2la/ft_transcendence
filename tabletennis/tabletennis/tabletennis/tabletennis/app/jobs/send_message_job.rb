class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    mine = ApplicationController.render(
      partial: 'messages/mine',
      locals: { message: message }
    )

    theirs = ApplicationController.render(
      partial: 'messages/theirs',
      locals: { message: message }
    )

    ActionCable.server.broadcast "chat_room_channel_#{message.chat_room_id}", {mine: mine, theirs: theirs, message: message}
  end
end
