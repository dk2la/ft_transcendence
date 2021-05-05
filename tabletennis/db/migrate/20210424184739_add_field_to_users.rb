class AddFieldToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :rating, :integer, :default => 1000
    add_column :users, :photo, :text, default: "/assets/standart_avatar.png"
  end
end
