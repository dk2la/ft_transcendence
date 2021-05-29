class CreateGuildWars < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_wars do |t|
      t.string  :status, default: "pending"
      t.references :sender_guild, references: :guilds, foreign_key: { to_table: :guilds } 
      t.references :recipient_guild, references: :guilds, foreign_key: { to_table: :guilds }
      t.string :war_time_begin
      t.integer :war_time_duration
      t.integer :battle_begin
      t.integer :battle_end
      t.integer :sender_victoies, default: 0
      t.integer :recipient_victories, default: 0
      t.integer :max_ignored_invites
      t.integer :max_time_of_ignoring_battle
      t.boolean :add_ones
      t.boolean :casual_enabled
      t.boolean :ladder_enabled
      t.boolean :tournament_enabled
      t.boolean :is_delay_war
      t.integer :bank_points, default: 50
      t.integer :duration, default: 2
      t.timestamps
    end
  end
end
