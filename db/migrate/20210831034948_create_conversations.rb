class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :created_by, index: true, foreign_key: {to_table: :users}, type: :uuid, null: true
      t.integer :master_podcast_id, null: false
      t.string :conversation_sid
      t.binary :message

      t.timestamps

      t.index :master_podcast_id
    end
  end
end
