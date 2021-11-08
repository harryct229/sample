class AddParentGroupIdToGroups < ActiveRecord::Migration[6.0]
  def up
    change_table :groups do |t|
      t.references :parent_group, index: true, foreign_key: {to_table: :groups}, type: :uuid, null: true
    end
  end

  def down
    change_table :groups do |t|
      t.remove_references :parent_group, index: true, foreign_key: {to_table: :groups}, type: :uuid, null: true
    end
  end
end
