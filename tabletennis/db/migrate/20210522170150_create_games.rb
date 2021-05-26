class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.text :background, default: "/assets/game_back.gif"

      t.references :player1, references: :users, foreign_key: { to_table: :users }
      t.references :player2, references: :users, foreign_key: { to_table: :users }
      t.string :winner, default: "No one"
      t.string :loser, default: "No one"
      
      t.boolean :is_finished, default: false
      t.timestamps
    end
  end
end
