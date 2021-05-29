class CreateTournamentMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :tournament_members do |t|
      t.references :player, references: :users, foreign_key: { to_table: :users }
      t.references :tournament
      t.integer :player_wins
      t.timestamps
    end
  end
end
