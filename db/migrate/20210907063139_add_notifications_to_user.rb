class AddNotificationsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notifications, :integer, array: true, null: false, default: []
  end
end
