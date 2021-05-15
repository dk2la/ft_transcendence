class CreateGameMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_members do |t|
      t.references :first_player
      t.references :second_player
      t.integer :winner, default: 0
      t.timestamps
    end
  end
end
