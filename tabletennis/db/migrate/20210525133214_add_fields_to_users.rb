class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_ingame, :boolean, default: false
    add_column :users, :is_queueing, :boolean, default: false
  end
end
