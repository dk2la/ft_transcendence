class CreateDirectRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :direct_rooms do |t|
      t.references :first_user, references: :users, foreign_key: { to_table: :users }
      t.references :second_user, references: :users, foreign_key: { to_table: :users }
      t.references :chat_room
      t.timestamps
    end
  end
end
