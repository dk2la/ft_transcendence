class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :status
      t.integer :count
      t.timestamps
    end
  end
end
