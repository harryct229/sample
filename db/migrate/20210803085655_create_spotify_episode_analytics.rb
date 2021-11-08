class CreateSpotifyEpisodeAnalytics < ActiveRecord::Migration[6.1]
  def change
    create_table :spotify_episode_analytics, id: :uuid do |t|
      t.integer :episode_id
      t.string :claimed_spotify_link
      t.json :gender_distribution, default: {}
      t.json :country_distribution, default: {}
      t.json :age_distribution, default: {}
      t.integer :starts
      t.integer :listeners
      t.integer :streams

      t.timestamps

      t.index ["episode_id"], name: "index_spotify_episode_analytics_on_episode_id"
    end
  end
end
