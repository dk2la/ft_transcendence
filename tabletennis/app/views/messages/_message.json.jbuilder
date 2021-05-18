json.extract! message, :id, :content, :user_id, :chat_room_id, :created_at, :updated_at
json.url message_path(message, format: :json)