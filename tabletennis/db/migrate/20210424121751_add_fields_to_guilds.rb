class AddFieldsToGuilds < ActiveRecord::Migration[6.1]
  def change
    add_column :guilds, :name, :string
    add_column :guilds, :anagram, :string
    add_column :guilds, :description, :text
    add_column :guilds, :rating, :integer, default: 1000
    add_column :guilds, :photo, :text, default: "/assets/standart_guild_avatar.png"
  end
end
