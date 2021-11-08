class AddPurposeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :purpose, :integer, default: 1, null: false
  end
end
