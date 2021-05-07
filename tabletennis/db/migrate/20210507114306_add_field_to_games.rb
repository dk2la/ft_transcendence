class AddFieldToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :background, :text, default: "/assets/game_back.gif"
  end
end
