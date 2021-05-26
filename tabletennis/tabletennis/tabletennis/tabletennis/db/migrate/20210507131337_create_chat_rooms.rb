class CreateChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.boolean :private, default: false
      t.string :passcode, default: nil

      t.timestamps
    end
  end
end
