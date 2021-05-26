class CreateGuildMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_members do |t|
      t.integer :user_id
      t.integer :guild_id
      t.integer :user_role

      t.timestamps
    end
  end
end
