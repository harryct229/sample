class AddPublisherIdToUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.references :publisher, index: true, foreign_key: {to_table: :publishers}, type: :uuid, null: true
    end
  end

  def down
    change_table :users do |t|
      t.remove_references :publisher, index: true, foreign_key: {to_table: :publishers}, type: :uuid, null: true
    end
  end
end
