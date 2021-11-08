class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :podcasts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :master_podcast_id
      t.integer :temporary_podcast_id
      t.string :website
      t.text :name
      t.text :artist_name
      t.string :feed_url
      t.string :additional_feed_url
      t.string :image_url
      t.string :owner_email
      t.date :start_date
      t.integer :listener_count, default: 0
      t.integer :reach_count, default: 0
      t.integer :subscriber_count, default: 0
      t.integer :episode_count, default: 0
      t.integer :frequency, default: 0
      t.boolean :is_explicit, default: false
      t.integer :state

      t.timestamps

      t.index :master_podcast_id
      t.index :temporary_podcast_id
    end
  end
end
