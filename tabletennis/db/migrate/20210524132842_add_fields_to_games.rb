class AddFieldsToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :long_paddles, :boolean, default: false
    add_column :games, :name_player1, :string
    add_column :games, :name_player2, :string
    add_column :games, :gametype, :string, default: "casual"
    add_column :games, :extra_speed, :boolean, default: false
    add_column :games, :tournament_id, :bigint
  end
end
