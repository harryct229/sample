class CreateUserGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :user_groups, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.integer :role, default: 0, null: false

      t.timestamps
    end
  end
end
