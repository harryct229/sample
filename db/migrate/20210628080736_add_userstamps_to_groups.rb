class AddUserstampsToGroups < ActiveRecord::Migration[6.0]
  def up
    change_table :groups do |t|
      t.references :created_by, index: true, foreign_key: {to_table: :users}, type: :uuid, null: true
      t.references :updated_by, index: true, foreign_key: {to_table: :users}, type: :uuid, null: true
    end
  end

  def down
    change_table :groups do |t|
      t.remove_references :created_by, index: true, foreign_key: {to_table: :users}, type: :uuid, null: true
      t.remove_references :updated_by, index: true, foreign_key: {to_table: :users}, type: :uuid, null: true
    end
  end
end
