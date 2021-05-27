class CreateDuels < ActiveRecord::Migration[6.1]
  def change
    create_table :duels do |t|

      t.references :sender, references: :users, foreign_key: { to_table: :users }
      t.references :receiver, references: :users, foreign_key: { to_table: :users }
      t.boolean :confirmed, default: false
      t.timestamps
    end
  end
end
