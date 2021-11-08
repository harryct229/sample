class AddPasswordChangedAtToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_changed_at, :datetime
  end
end
