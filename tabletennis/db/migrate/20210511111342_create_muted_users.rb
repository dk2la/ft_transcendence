class CreateMutedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :muted_users do |t|
      t.references :user
      t.references :chat_room
      
      t.timestamps
    end
  end
end
