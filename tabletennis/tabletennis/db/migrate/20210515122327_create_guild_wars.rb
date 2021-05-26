class CreateGuildWars < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_wars do |t|
      t.string  :status
      t.references :sender_guild, references: :guilds, foreign_key: { to_table: :guilds } 
      t.references :recipient_guild, references: :guilds, foreign_key: { to_table: :guilds }
      t.integer :war_time_begin
      t.integer :war_time_end
      t.integer :battle_begin
      t.integer :battle_end
      t.integer :points
      t.integer :max_ignored_invites
      t.boolean :add_ones

      t.timestamps
    end
  end
end
