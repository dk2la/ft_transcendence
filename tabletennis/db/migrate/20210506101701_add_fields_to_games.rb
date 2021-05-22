class AddFieldsToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :name, :string
  end
end
