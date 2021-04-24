class AddFieldsToGuilds < ActiveRecord::Migration[6.1]
  def change
    add_column :guilds, :name, :string
    add_column :guilds, :anagram, :string
    add_column :guilds, :description, :text
    add_column :guilds, :rating, :integer
  end
end
