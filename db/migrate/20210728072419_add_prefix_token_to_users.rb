class AddPrefixTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :prefix_token, :string
    add_index :users, :prefix_token, unique: true
  end
end
