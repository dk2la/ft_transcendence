class CreatePairs < ActiveRecord::Migration[6.1]
  def change
    create_table :pairs do |t|
      t.references :player1
      t.references :player2
      t.integer :round
      t.references :game
      t.references :tournament
      t.timestamps
    end
  end
end
