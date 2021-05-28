class CreateGuildWars < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_wars do |t|
      t.string  :status
      t.references :sender_guild, references: :guilds, foreign_key: { to_table: :guilds } 
      t.references :recipient_guild, references: :guilds, foreign_key: { to_table: :guilds }
      t.string :war_time_begin
      t.integer :war_time_duration
      t.integer :battle_begin
      t.integer :battle_end
      t.integer :sender_victoies
      t.integer :recipient_victories
      t.integer :max_ignored_invites
      t.integer :max_time_of_ignoring_battle
      t.boolean :add_ones
      t.boolean :casual_enabled
      t.boolean :ladder_enabled
      t.boolean :tournament_enabled
      t.boolean :is_delay_war
      t.timestamps
    end
  end
end
