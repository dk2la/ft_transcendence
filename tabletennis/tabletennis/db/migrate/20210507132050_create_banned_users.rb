class CreateBannedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :banned_users do |t|
      t.references :user
      t.references :chat_room

      t.timestamps
    end
  end
end
