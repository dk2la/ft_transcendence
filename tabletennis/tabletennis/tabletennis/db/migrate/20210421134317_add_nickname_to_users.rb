class AddNicknameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :status, :integer, default: 0
  end
end
