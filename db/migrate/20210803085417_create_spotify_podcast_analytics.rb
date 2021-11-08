class CreateSpotifyPodcastAnalytics < ActiveRecord::Migration[6.1]
  def change
    create_table :spotify_podcast_analytics, id: :uuid do |t|
      t.references :podcast, null: false, foreign_key: true, type: :uuid
      t.string :claimed_spotify_link
      t.json :gender_distribution, default: {}
      t.json :country_distribution, default: {}
      t.json :age_distribution, default: {}
      t.integer :starts
      t.integer :listeners
      t.integer :streams
      t.integer :followers

      t.timestamps
    end
  end
end
