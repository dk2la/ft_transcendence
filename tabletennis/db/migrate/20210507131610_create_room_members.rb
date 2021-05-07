class CreateRoomMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :room_members do |t|
      t.references :user
      t.references :chat_room
      t.integer :member_role, default: 0
    
      t.timestamps
    end
  end
end
