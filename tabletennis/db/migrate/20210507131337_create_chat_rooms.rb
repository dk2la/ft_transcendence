class CreateChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.boolean :private, default: false
      t.string :passcode, default: nil
<<<<<<< HEAD
=======
      t.boolean :direct, default: false
>>>>>>> 6d5749fbb98bbae5bd1b452f7a3e0b69667421ed

      t.timestamps
    end
  end
end
